class RemoveStatusFromGround < ActiveRecord::Migration
  def change
    remove_column :grounds, :status, :string
  end
end
