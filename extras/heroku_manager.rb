class HerokuManager
  def heroku
    @heroku ||= Heroku::API.new
  end

  def get_workers
    p ">>> get_workers"
    worker_count = heroku.get_ps(ENV['APP_NAME']).body.count { |p| p["process"] =~ /worker\.\d?/ }
    p ">>> #{worker_count}"
    worker_count
  end

  def set_workers(count)
    p ">>> set_workers #{count}"
    heroku.post_ps_scale(ENV['APP_NAME'], 'worker', count)
  end
end 
