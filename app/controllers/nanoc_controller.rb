require 's3_file'

class NanocController < ApplicationController
  def compile
    site = Nanoc::Site.new({
      :output_dir   => 'tmp/nanoc_output',
      :data_sources => [
        # {
        #   :type         => 'filesystem_unified',
        #   :items_root   => '/',
        #   :layouts_root => '/',
        #   :config       => {} 
        # },
        {
          :type   => 's3'
        }
      ],
      :input_bucket   => 'nanoccer-input',
      :output_bucket  => 'nanoccer-output'
    })

    begin
      site.compile

      Rails.logger.warn site
      Rails.logger.warn site.config

      S3File.connect  site.config[:output_bucket]
      S3File.copy     'nanoc_output', 'tmp/', site.config[:output_bucket]

      render :text => 'uploaded result to s3'
    rescue Exception => e
      render :text => "EXCEPTION: #{e}\n#{e.backtrace}", :content_type => Mime::TEXT
    end
  end
end
