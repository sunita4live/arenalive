class AddSlotToBookingTime < ActiveRecord::Migration
  def change
    add_column :booking_times, :slot, :string
  end
end
