require "vfs"
require "vos"
require 'vos/drivers/s3'

module S3Bucket
  @@buckets = {}
  def self.get bucket_name
    unless @@buckets[bucket_name]
      driver = Vos::Drivers::S3.new \
        access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket:            bucket_name

      @@buckets[bucket_name] = Vos::Box.new driver
    end
    @@buckets[bucket_name]
  end
end
