class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :input_bucket
      t.string :output_bucket
      t.string :preview_bucket
      t.string :aws_key
      t.string :aws_secret

      t.timestamps
    end
  end
end
