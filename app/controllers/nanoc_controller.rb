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
      render :text => site.compile
    rescue Exception => e
      render :text => "EXCEPTION: #{e}"
    end
  end
end
