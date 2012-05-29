class DropTimestampsFromWebsites < ActiveRecord::Migration
  def up
    remove_column :websites, :created_at
    remove_column :websites, :updated_at
  end

  def down
  end
end
