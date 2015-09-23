class AddWeekendPriceAndWeekdayPriceAndPhoneAndCourtAndAttentionMessageToGround < ActiveRecord::Migration
  def change
    add_column :grounds, :weekend_price, :float
    add_column :grounds, :weekday_price, :float
    add_column :grounds, :phone, :string
    add_column :grounds, :court, :integer
    add_column :grounds, :attention_message, :text
  end
end
