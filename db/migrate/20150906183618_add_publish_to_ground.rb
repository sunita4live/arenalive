class AddPublishToGround < ActiveRecord::Migration
  def change
    add_column :grounds, :publish, :boolean, :default => false
  end
end
