require 's3_bucket'

class NanocController < ApplicationController
  def compile
    site = Nanoc::Site.new({
      :output_dir   => 'tmp/nanoc_output',
      :data_sources => [
        {
          :type         => 'filesystem_unified',
          :items_root   => '/',
          :layouts_root => '/',
          :config       => {} 
        }
      ],
      :input_bucket   => 'nanoccer-input',
      :output_bucket  => 'nanoccer-output'
    })

    begin
      input_bucket  = S3Bucket.get site.config[:input_bucket]
      output_bucket = S3Bucket.get site.config[:output_bucket]

      # input_bucket['content'].copy_to Rails.root.to_s.to_entry['content'], :bang => false
      # input_bucket['layouts'].copy_to Rails.root.to_s.to_entry['layouts'], :bang => false

      site.compile

      Rails.logger.warn site
      Rails.logger.warn site.config

      'tmp/nanoc_output'.to_entry.copy_to output_bucket['']

      render :text => 'uploaded result to s3'
    rescue Exception => e
      render :text => "EXCEPTION: #{e}\n#{e.backtrace}", :content_type => Mime::TEXT
    end
  end
end
