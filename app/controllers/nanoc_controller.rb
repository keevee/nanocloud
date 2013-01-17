require 's3_bucket'

class CompilationException < Exception
end

class NanocController < ApplicationController
  before_filter :authenticate_user!

  def index
    @websites = current_user.websites
  end

  def compile
    if @website = Website.find_by_name(params[:name])
      if current_user.websites.include?(@website)
        Delayed::Job.enqueue(CompilerJob.new(@website.id, params[:preview]!='false'))
      else
        @output = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
      end
    else
    end

    render 'output', :layout => false
  end

end
