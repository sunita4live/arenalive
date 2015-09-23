class AddStatusToGround < ActiveRecord::Migration
  def change
    add_column :grounds, :status, :boolean
  end
end
