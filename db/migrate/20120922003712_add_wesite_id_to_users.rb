class AddWesiteIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website_id, :integer
  end
end
