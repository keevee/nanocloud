class AddStatusToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :status, :string
  end
end
