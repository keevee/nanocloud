class CompilationException < Exception
end

class Website < ActiveRecord::Base
  attr_accessible :aws_key, :aws_secret, :input_bucket_name, :name, :output_bucket_name, :preview_bucket_name
  has_many :users

  def compile()
    nanoc = Nanoc::Site.new({})

    begin
      input_bucket  = S3Bucket.get input_bucket_name,  aws_key, aws_secret
      output_bucket = S3Bucket.get output_bucket_name, aws_key, aws_secret

      local = Rails.root.to_s.to_entry

      local['content'].destroy
      local['layouts'].destroy
      local['output'].destroy

      Rails.logger.warn ">>> Starting import of content ..."
      input_bucket['content'].copy_to local['content']
      input_bucket['layouts'].copy_to local['layouts']
      input_bucket['lib/helpers.rb'].copy_to  local['lib/helpers.rb']
      input_bucket['lib/filters.rb'].copy_to  local['lib/filters.rb']

      Rails.logger.warn ">>> Starting compilation ..."
      begin
        nanoc.compile
      rescue Exception => e
        raise CompilationException, e.message
      end

      Rails.logger.warn ">>> Starting upload of result ..."
      local['output'].copy_to output_bucket['']

      update_attribute :compiled_at, Time.now

      message = 'Success! Uploaded result to S3.'
    rescue SocketError, AWS::Errors::Base => e
      message = "Error: Could not connect to buckets."
    rescue CompilationException => e
      Rails.logger.warn e.class
      Rails.logger.warn e
      Rails.logger.warn e.backtrace
      message = "Error: #{e.class} #{e}\n"
    rescue Exception => e
      message = "Error: #{e.class} #{e}\n"
    end
    message
  end

end
