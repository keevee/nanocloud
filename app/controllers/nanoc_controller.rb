require 's3_bucket'

class CompilationException < Exception
end

class NanocController < ApplicationController
  before_filter :authenticate_user!

  def index
    unless @website = current_user.website
      @message = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
      return
    end

    return if params[:todo].blank?

    nanoc = Nanoc::Site.new({})

    begin
      input_bucket  = S3Bucket.get @website.input_bucket,  @website.aws_key, @website.aws_secret
      output_bucket = S3Bucket.get @website.output_bucket, @website.aws_key, @website.aws_secret

      local = Rails.root.to_s.to_entry

      local['content'].destroy
      local['layouts'].destroy
      local['output'].destroy

      Rails.logger.warn ">>> Starting import of content ..."
      input_bucket['content'].copy_to         local['content']
      input_bucket['layouts'].copy_to         local['layouts']
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

      @message =  'Success! Uploaded result to s3.'
    rescue SocketError, AWS::Errors::Base  => e
      @message = "Error: Could not connect to buckets."
    rescue CompilationException => e
      Rails.logger.warn e
      @message = "Error: #{e.class} #{e}\n#{e.backtrace}"
    rescue Exception => e
      Rails.logger.warn e
      @message = "Error: #{e.class} #{e}\n#{e.backtrace}"
    end
  end
end
