require "vfs"
require "vos"
require 'vos/drivers/ssh'

module SFTPBucket
  @@buckets = {}
  def self.get host_name, folder_name, user_name, password
    bucket_name = "#{host_name}:#{folder_name}"
    unless @@buckets[bucket_name]
      driver = Vos::Drivers::Ssh.new \
        host:     host_name,
        root:     folder_name,
        user:     user_name,
        password: password

      @@buckets[bucket_name] = Vos::Box.new driver
    end
    @@buckets[bucket_name]
  end

end
