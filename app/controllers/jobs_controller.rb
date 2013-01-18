class JobsController < ApplicationController
  def check
    unless @job = Delayed::Job.find(params[:id])
      @success = true
    end
    render :layout => false
  end
end
