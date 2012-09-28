class RenameBucketAttributes < ActiveRecord::Migration
  def change
    rename_column :websites, :input_bucket,   :input_bucket_name
    rename_column :websites, :output_bucket,  :output_bucket_name
    rename_column :websites, :preview_bucket, :preview_bucket_name
  end
end
