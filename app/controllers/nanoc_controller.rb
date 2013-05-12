require 's3_bucket'

class CompilationException < Exception
end

class NanocController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.id == 1
      @websites = Website.all
    else
      @websites = current_user.websites
    end
  end

  def compile
    if @website = Website.find_by_name(params[:name])
      if current_user.websites.include?(@website)
        Delayed::Job.enqueue(CompilerJob.new(@website.id, params[:preview]=='true'))
      else
        @output = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
      end
    else
    end

    render 'output', :layout => false
  end

end
