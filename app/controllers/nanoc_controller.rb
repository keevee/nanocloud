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
      content = File.read('tmp/test/index.html')
      Rails.logger.warn content

      AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      )

      AWS::S3::Bucket.find 'nanoccer'

      Dir["tmp/nanoc_output/*"].each do |file|
        # Don't upload this file!
        if file != __FILE__
          Rails.logger.warn "Uploading #{file}.."
          AWS::S3::S3Object.store(file, open(file), 'nanoccer')
          Rails.logger.warn "done!"
        end
      end

      render :text => 'uploaded result to s3'
    rescue Exception => e
      render :text => "EXCEPTION: #{e}"
    end
  end
end
