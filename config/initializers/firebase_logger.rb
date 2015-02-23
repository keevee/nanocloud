class FirebaseLogger < Logger
  @jobid = nil
  def initialize(jobid)
    Rails.logger.warn "FB Base: https://nanocloud.firebaseio.com/#{ENV['APP_NAME']}/logs"
    Firebase.base_uri = "https://nanocloud.firebaseio.com/#{ENV['APP_NAME']}/logs"
    Firebase.delete(@jobid)
    @jobid = jobid
  end

  def add(severity, message = nil, progname = nil, &block)
    Rails.logger.add(severity, "** #{message}" , progname, &block)
    puts "** #{progname}"
    Firebase.push(@jobid, {:severity => severity, :message => progname.to_s})
  end
end
