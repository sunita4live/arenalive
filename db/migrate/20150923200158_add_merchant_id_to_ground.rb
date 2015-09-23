class AddMerchantIdToGround < ActiveRecord::Migration
  def change
    add_column :grounds, :merchant_id, :string
  end
end
