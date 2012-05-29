require 's3_bucket'

class NanocController < ApplicationController
  def compile
    unless (website_name = params[:website]) && (website = Website.find_by_name(website_name))
      render :text => "you must specify a valid website"
      return false
    end

    site = Nanoc::Site.new({})

    begin
      input_bucket  = S3Bucket.get website.input_bucket,  website.aws_key, website.aws_secret
      output_bucket = S3Bucket.get website.output_bucket, website.aws_key, website.aws_secret

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

      render :text => 'Success! Uploaded result to s3.'
    rescue SocketError, AWS::Errors::Base  => e
      render :text => "Error: Could not connect to buckets.", :content_type => Mime::TEXT
    rescue Exception => e
      render :text => "Error: #{e.class} #{e}\n#{e.backtrace}", :content_type => Mime::TEXT
    end
  end
end
