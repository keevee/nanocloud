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
    website = Website.find(website_id)

    Rails.logger.warn "\n\nCompilerJob#perform - website:"
    Rails.logger.warn website.inspect

    website.compile(preview)
  end
end

class Website < ActiveRecord::Base
  attr_accessible :input_bucket_name, :name, :output_bucket_name, :preview_bucket_name, :user_id, :host, :username, :password
  belongs_to :user

  default_scope order('name ASC')

  SOURCES = %w{ content layouts lib/helpers_local.rb lib/filters_local.rb rules_preprocess.rb rules_compile.rb config.yaml }
  DEFAULTS = { 'layouts-default' => 'layouts' }

  def get_input_bucket
    if host? && password?
      @logger.info "connecting to input SFTP bucket '#{input_bucket_name}' ..."
      SFTPBucket.get host, input_bucket_name, username, password
    else
      @logger.info "connecting to input S3 bucket '#{input_bucket_name}' ..."
      S3Bucket.get input_bucket_name, user.aws_key, user.aws_secret
    end
  end

  def get_output_bucket(preview)
    bucket_name = preview ? preview_bucket_name : output_bucket_name
    if host? && password?
      @logger.info "connecting to output SFTP bucket '#{bucket_name}' ..."
      SFTPBucket.get host, bucket_name, username, password
    else
      @logger.info "connecting to output S3 bucket '#{bucket_name}' ..."
      S3Bucket.get bucket_name, user.aws_key, user.aws_secret
    end
  end

  def final_error message
    message = @logger.error message
    @logger.error "FAILED :-("
    message
  end

  def compile(preview = true)
    @logger = FirebaseLogger.new self.delayed_job_id
    begin
      unless ENV['NC_RUN_LOCAL']
        input_bucket  = get_input_bucket
        local         = Rails.root.to_s.to_entry

        local['output'].destroy

        @logger.info "importing from input bucket ..."
        SOURCES.each do |file|
          local[file].destroy
          if input_bucket[file].exist?
            @logger.info "importing: #{file} ..."
            input_bucket[file].copy_to local[file]
          else 
            @logger.warn "not found: #{file} ..."
          end
        end
        @logger.info "copying defaults ..."
        DEFAULTS.each do |source, target|
          @logger.info "copying: #{source} ..."
          `cp #{source}/* #{target}`
        end
      else
        @logger.info "ENV['NC_RUN_LOCAL'] set, running locally"
      end

      @logger.info "compiling ..."
      output = `bundle exec nanoc co 2>&1`
      raise NanocCompilationException, output unless $?.success?

      @logger.info output

      unless ENV['NC_RUN_LOCAL']
        output_bucket = get_output_bucket(preview)
        @logger.info "deleting output bucket ..."
        output_bucket.entries.each{|e| e.destroy }

        @logger.info "exporting to output bucket ..."
        local['output'].copy_to output_bucket['']

        update_attribute :compiled_at, Time.now
        @logger.info "DONE :-)"
      end

      message = 'Success! Uploaded result.'
    rescue SocketError, AWS::Errors::Base => e
      message = final_error "cannot connect to bucket. #{e.message}"
    rescue NanocCompilationException => e
      message = final_error e.message
    rescue Exception => e
      message = final_error e.message
    end
    message
  end

end
