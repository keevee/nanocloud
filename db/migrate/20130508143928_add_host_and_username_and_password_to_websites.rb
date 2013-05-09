class AddHostAndUsernameAndPasswordToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :host, :string
    add_column :websites, :username, :string
    add_column :websites, :password, :string
  end
end
