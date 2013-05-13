class JobsController < ApplicationController
  def check
    @success = false
    unless @job = Delayed::Job.find_by_id(params[:id])
      @success = true
    end
    render :layout => false
  end
end
