require 's3_bucket'

class CompilationException < Exception
end

class NanocController < ApplicationController
  before_filter :authenticate_user!

  def index
    unless @website = current_user.website
      @message = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
    end
  end

  def compile
    if @website = current_user.website
      flash[:info] = @website.compile(params[:preview]!='false')
    else
      flash[:info] = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
    end

    Rails.logger.warn "REDIRECT TO DASHBOARD"
    redirect_to '/dashboard/'
  end

end
