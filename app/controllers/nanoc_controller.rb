class NanocController < ApplicationController
  def compile
    site = Nanoc::Site.new({
      :output_dir   => 'tmp',
      :data_sources => [{
        :type         => 'filesystem_unified',
        :items_root   => '/',
        :layouts_root => '/',
        :config       => {} 
      }]
    })
    begin
      site.compile
      render :text => File.read('tmp/test/index.html')
    rescue Exception => e
      render :text => "EXCEPTION: #{e}"
    end
  end
end
