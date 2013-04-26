require "vfs"
require "vos"
require 'vos/drivers/s3'

module S3Bucket
  @@buckets = {}
  def self.get bucket_name, aws_key, aws_secret
    unless @@buckets[bucket_name]
      driver = Vos::Drivers::S3.new \
        access_key_id:     aws_key,
        secret_access_key: aws_secret,
        bucket:            bucket_name,
        write_options:     {:cache_control => 'public,max-age=31536000'}

      @@buckets[bucket_name] = Vos::Box.new driver
    end
    @@buckets[bucket_name]
  end
end
