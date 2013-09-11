require 's3_bucket'
require 'sftp_bucket'
require 'managed_job'
require 'heroku_manager'

class NanocCompilationException < Exception
end

class CompilerJob < ManagedJob
  attr_accessor :website_id, :preview

  def initialize(website_id, preview=true)
    self.website_id = website_id
    self.preview    = preview
    super()
  end

  def perform
    Website.find(website_id).compile(preview)
  end
end

class Website < ActiveRecord::Base
  attr_accessible :input_bucket_name, :name, :output_bucket_name, :preview_bucket_name, :user_id
  belongs_to :user

  default_scope order('name ASC')

  SOURCES = %w{ content layouts lib/helpers_local.rb lib/filters_local.rb rules_preprocess.rb rules_compile.rb config.yaml }

  def get_input_bucket
    if host && password
      Rails.logger.info ">>> connecting to input SFTP bucket '#{input_bucket_name}' ..."
      SFTPBucket.get host, input_bucket_name, username, password
    else
      Rails.logger.info ">>> connecting to input S3 bucket '#{input_bucket_name}' ..."
      S3Bucket.get input_bucket_name, user.aws_key, user.aws_secret
    end
  end

  def get_output_bucket(preview)
    bucket_name = preview ? preview_bucket_name : output_bucket_name
    if host && password
      Rails.logger.info ">>> connecting to output SFTP bucket '#{bucket_name}' ..."
      SFTPBucket.get host, bucket_name, username, password
    else
      Rails.logger.info ">>> connecting to output S3 bucket '#{bucket_name}' ..."
      S3Bucket.get bucket_name, user.aws_key, user.aws_secret
    end
  end

  def compile(preview = true)
    logger = FirebaseLogger.new self.delayed_job_id
    Rails.logger.warn "####logger: #{logger.inspect} - #{}###"
    begin
      unless ENV['NC_RUN_LOCAL']
        input_bucket  = get_input_bucket
        output_bucket = get_output_bucket(preview)
        local         = Rails.root.to_s.to_entry

        local['output'].destroy

        SOURCES.each do |file|
          local[file].destroy
          if input_bucket[file].exist?
            logger.info ">>> importing: #{file} ..."
            input_bucket[file].copy_to local[file]
            logger.warn "ok."
          else 
            logger.info ">>> not found: #{file} ..."
          end
        end
      else
        logger.info "ENV['NC_RUN_LOCAL'] set, running locally"
      end

      logger.info "##########"

      begin
        # nanoc.compile
        logger.warn ">>> Compilation:"
        logger.warn `bundle exec nanoc co`
      rescue Exception => e
        logger.error ">>> nanoc compilation exception:"
        logger.error e.class
        logger.error e
        logger.error e.backtrace
        raise NanocCompilationException, e.message
      end

      unless ENV['NC_RUN_LOCAL']
        logger.info ">>> exporting: output ..."
        local['output'].copy_to output_bucket['']

        update_attribute :compiled_at, Time.now
      end

      message = 'Success! Uploaded result.'
    rescue SocketError, AWS::Errors::Base => e
      message = "Socket Error: Could not connect to buckets."
      logger.error e
      logger.error e.backtrace
    rescue NanocCompilationException => e
      message = "Compilation Error: #{e.class} #{e}\n"
    rescue Exception => e
      message = "Unknown Error: #{e.class} #{e}\n"
      logger.error "#{e}"
      logger.error e.backtrace
    end
    message
  end

end
