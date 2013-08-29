class AddDelayedJobIdToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :delayed_job_id, :integer
  end
end
