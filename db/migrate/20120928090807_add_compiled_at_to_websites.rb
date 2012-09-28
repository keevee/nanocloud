class AddCompiledAtToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :compiled_at, :datetime
  end
end
