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

      content_dir = Rails.root.to_s.to_entry['content']
      layouts_dir = Rails.root.to_s.to_entry['layouts']

      content_dir.destroy
      layouts_dir.destroy

      Rails.logger.warn ">>> Starting import of content ..."
      input_bucket['content'].copy_to content_dir
      input_bucket['layouts'].copy_to layouts_dir

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
