class ManagedJob
  def initialize
    if Rails.env.production?
      @heroku ||= HerokuManager.new
      @heroku.set_workers(1) if (@heroku.get_workers == 0)
    end 
  end

  def perform; end

  def after(job)
    if Rails.env.production?
      @heroku ||= HerokuManager.new
      @heroku.set_workers(0) if (job_count == 1)
    end
  end

  def job_count
    Delayed::Job.all(:conditions => {failed_at: nil}).length
  end
end

class TestJob < ManagedJob
  def perform
    message = "#{Time.now} TestJob completed"
    puts message
  rescue Exception => e
    puts "#{Time.now} ERROR: #{e.message}"
  end
end
