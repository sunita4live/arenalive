class AddTimeslotIdToBookingTime < ActiveRecord::Migration
  def change
    add_column :booking_times, :timeslot_id, :integer
  end
end
