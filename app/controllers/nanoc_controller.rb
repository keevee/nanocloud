require 's3_bucket'

class NanocController < ApplicationController
  def compile
    unless (input = params[:input]) && (output = params[:output])
      render :text => "you must specify input and output"
      return false
    end

    site = Nanoc::Site.new({})

    begin
      input_bucket  = S3Bucket.get input
      output_bucket = S3Bucket.get output

      Rails.logger.warn ">>> Starting import of content ..."
      input_bucket['content'].copy_to Rails.root.to_s.to_entry['content']
      input_bucket['layouts'].copy_to Rails.root.to_s.to_entry['layouts']

      Rails.logger.warn ">>> Starting compilation ..."
      site.compile

      Rails.logger.warn ">>> Starting upload of result ..."
      'output'.to_entry.copy_to output_bucket['']

      render :text => 'uploaded result to s3'
    rescue Exception => e
      render :text => "EXCEPTION: #{e}\n#{e.backtrace}", :content_type => Mime::TEXT
    end
  end
end
