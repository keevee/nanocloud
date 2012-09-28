class Website < ActiveRecord::Base
  attr_accessible :aws_key, :aws_secret, :input_bucket, :name, :output_bucket, :preview_bucket
  has_many :users

  def compile()
    site = Nanoc::Site.new({})

    begin
      input_bucket = S3Bucket.get  input_bucket,  aws_key, aws_secret
      output_bucket = S3Bucket.get output_bucket, aws_key, aws_secret

      local = Rails.root.to_s.to_entry

      local['content'].destroy
      local['layouts'].destroy
      local['output'].destroy

      Rails.logger.warn ">>> Starting import of content ..."
      input_bucket['content'].copy_to local['content']
      input_bucket['layouts'].copy_to local['layouts']

      Rails.logger.warn ">>> Starting compilation ..."
      site.compile

      Rails.logger.warn ">>> Starting upload of result ..."
      local['output'].copy_to output_bucket['']

      update_attribute :compiled_at, Time.now

      message = 'Success! Uploaded result to s3.'
    rescue SocketError, AWS::Errors::Base => e
      message = "Error: Could not connect to buckets."
    rescue Exception => e
      message = "Error: #{e.class} #{e}\n#{e.backtrace}"
    end
    message
  end

end
