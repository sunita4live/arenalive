class AddBookedAndPersonToTimeslot < ActiveRecord::Migration
  def change
    add_column :timeslots, :booked, :boolean, :default => false
    add_column :timeslots, :person, :string
  end
end
