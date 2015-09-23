class AddBookingIdToBookingTime < ActiveRecord::Migration
  def change
    add_column :booking_times, :booking_id, :integer
  end
end
