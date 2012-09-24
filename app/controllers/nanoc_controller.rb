require 's3_bucket'

class NanocController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:todo].blank?
      render
      return
    end
    website = current_user.website
    unless website
      @message = "You are not connected to a website yet. please ask us to make you connected"
      render
      return false
    end

    @message = website.compile
    render
  end

end
