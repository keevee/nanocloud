class NanocCompilationException < Exception
end

class Website < ActiveRecord::Base
  attr_accessible :aws_key, :aws_secret, :input_bucket_name, :name, :output_bucket_name, :preview_bucket_name
  has_many :users

  def compile(preview = true)
    begin
      Rails.logger.info ">>> connecting to input bucket '#{input_bucket_name}' ..."
      input_bucket  = S3Bucket.get input_bucket_name,  aws_key, aws_secret

      if preview
        Rails.logger.info ">>> connecting to preview bucket '#{preview_bucket_name}' ..."
        output_bucket  = S3Bucket.get preview_bucket_name,  aws_key, aws_secret
      else
        Rails.logger.info ">>> connecting to output bucket '#{output_bucket_name}' ..."
        output_bucket = S3Bucket.get output_bucket_name, aws_key, aws_secret
      end

      local = Rails.root.to_s.to_entry

      local['content'].destroy
      local['layouts'].destroy
      local['output'].destroy

      Rails.logger.info ">>> importing content ..."
      input_bucket['content'].copy_to                 local['content']
      Rails.logger.info ">>> importing layouts ..."
      input_bucket['layouts'].copy_to                 local['layouts']

      ['lib/helpers.rb', 'lib/filters.rb', 'Rules_preprocess_local', 'config.yaml'].each do |file|
        if input_bucket[file].exist?
          Rails.logger.info ">>> copying #{file}"
          input_bucket[file].copy_to local[file]
        end
      end

      # nanoc = Nanoc::Site.new('.')
      # nanoc = Nanoc::Site.new({})

      # Rails.logger.info "##########"
      # Rails.logger.info nanoc.config
      # Rails.logger.info "##########"

      begin
        # nanoc.compile
        `nanoc co`
      rescue Exception => e
        Rails.logger.error ">>> nanoc compilation exception:"
        Rails.logger.error e.class
        Rails.logger.error e
        Rails.logger.error e.backtrace
        raise NanocCompilationException, e.message
      end

      Rails.logger.info ">>> Starting upload of result ..."
      local['output'].copy_to output_bucket['']

      update_attribute :compiled_at, Time.now

      message = 'Success! Uploaded result to S3.'
    rescue SocketError, AWS::Errors::Base => e
      message = "Error: Could not connect to buckets."
      Rails.logger.error e
      Rails.logger.error e.backtrace
    rescue NanocCompilationException => e
      message = "Error: #{e.class} #{e}\n"
    rescue Exception => e
      message = "Error: #{e.class} #{e}\n"
    end
    message
  end

end
