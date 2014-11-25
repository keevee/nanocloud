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
    data = {}
    if @website = Website.find_by_name(params[:name])
      if current_user.websites.include?(@website)
        job = Delayed::Job.enqueue(CompilerJob.new(@website.id, params[:preview]=='true'))
        @website.update_attribute :delayed_job_id, job.id
        data[:job_id] = job.id
      else
        @output = "You are not connected to a website yet. Please <a href='mailto:post@momolog.info'>contact us</a> to set up your account.".html_safe
      end
    else
      Rails.logger.warn "Website not found #{params[:name]}"
    end

    redirect_to({:action => :index}.merge(data))
  end

end
