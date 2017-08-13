class HerokuManager
  def initialize app_name
    @app_name = app_name
    @api = PlatformAPI.connect_oauth ENV['HEROKU_API_KEY']
  end

  def get_workers
    p ">>> get_workers"
    list  = @api.dyno.list(@app_name)
    p ">>> #{list.inspect}"
    worker_count = list.count
    p ">>> #{worker_count}"
    worker_count
  end

  def get_last_dyno_id
    @api.dyno.list(@app_name).last['id']
  end

  def set_workers(count)
    p ">>> set_workers #{count}"
    current_count = get_workers

    return if current_count == count

    if current_count > count
      p ">>> stopping excess workers"
      (current_count - count).times do
        last_dyno_id = get_last_dyno_id
        p ">>> stopping #{last_dyno_id}"
        @api.dyno.stop @app_name, last_dyno_id
      end
    else
      p ">>> starting missing workers"
      (count - current_count).times do
        dyno = @api.dyno.create @app_name, {command: 'bundle exec rake jobs:work', size: 'Free'}
        p ">>> started #{dyno.inspect}"
      end
    end
  rescue Excon::Error::UnprocessableEntity => e
    error_info = JSON.parse(e.response.data[:body])
    p error_info
  end
end 
