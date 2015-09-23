class AddBookedAndPersonToBookingTime < ActiveRecord::Migration
  def change
    add_column :booking_times, :booked, :boolean, :default => false
    add_column :booking_times, :person, :integer
  end
end
