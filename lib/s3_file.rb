require "aws/s3"

module S3File
  include AWS::S3

  def self.connect bucket
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )
    AWS::S3::Bucket.find bucket
  end

  # copy one file to amazon, setting metadata as needed
  def self.copy_one_file file, fstat, bucket, opts = {}
    opts.reverse_merge!({
      :modified_only  => false,
      :prefix         => '',
      :dry_run        => false,
      :public         => true
    })

    content_encoding = nil

    options = {}
    options[:access]                = :public_read                if opts[:public]
    options["x-amz-meta-sha1_hash"] = `sha1sum #{file}`.split[0]  if @save_hash
    options["x-amz-meta-mtime"]     = fstat.mtime.getutc.to_i     if @save_time
    options["x-amz-meta-size"]      = fstat.size                  if @save_size

    sent_it = !opts[:modified_only]
    if opts[:modified_only]
      begin
        if S3Object.find("#{opts[:prefix]}#{file}", bucket).metadata["x-amz-meta-sha1_hash"] == options["x-amz-meta-sha1_hash"]
          # log("Skipping: #{file} in #{bucket}", 3)
        end
      rescue AWS::S3::NoSuchKey => ex
        # This file isn't there yet, so we need to send it
      end
    end

    S3Object.store("#{opts[:prefix]}#{file}", open(file), bucket, options) unless opts[:dry_run]
  end

  # Copy one file/dir from the system, recurssing if needed. Used for non-Ruby style globs
  def self.copy_one_file_or_dir name, base_dir, bucket, opts = {}
    opts.reverse_merge!({
      :deep           => true,
      :modified_only  => false,
      :prefix         => '',
      :dry_run        => false
    })

    return  if name[0,1] == '.'
    file_name = "#{base_dir}#{name}"
    fstat     = File.stat(file_name)

    copy_one_file(file_name, fstat, bucket, opts) if fstat.file? || fstat.symlink?

    puts opts[:deep]
    puts fstat.directory?

    if opts[:deep] && fstat.directory?
      my_base = file_name + '/'
      Dir.foreach(my_base) { |e| copy_one_file_or_dir(e, my_base, bucket, opts) }
    end
  end
end
