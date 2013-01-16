class AddAwsKeyAndAwsSecretToUsers < ActiveRecord::Migration
  def change
    add_column    :users,       :aws_key,     :string
    add_column    :users,       :aws_secret,  :string
    add_column    :admin_users, :aws_key,     :string
    add_column    :admin_users, :aws_secret,  :string

    remove_column :websites,    :aws_key
    remove_column :websites,    :aws_secret
  end

  def up
    add_column    :websites,    :aws_key,     :string
    add_column    :websites,    :aws_secret,  :string
  end
end
