require 's3_file'

class NanocController < ApplicationController
  def compile
    site = Nanoc::Site.new({
      :output_dir   => 'tmp/nanoc_output',
      :data_sources => [{
        :type         => 'filesystem_unified',
        :items_root   => '/',
        :layouts_root => '/',
        :config       => {} 
      }]
    })
    begin
      site.compile

      S3File.connect  'nanoccer'
      S3File.copy     'test', 'tmp/nanoc_output/', 'nanoccer'

      render :text => 'uploaded result to s3'
    rescue Exception => e
      render :text => "EXCEPTION: #{e}"
    end
  end
end
