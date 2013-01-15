class AddUserIdToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :user_id, :integer
    remove_column :users, :website_id, :integer
  end
end
