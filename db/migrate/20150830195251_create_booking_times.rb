class CreateBookingTimes < ActiveRecord::Migration
  def change
    create_table :booking_times do |t|
      t.datetime :time_of_booking
      t.boolean :status
      t.references :booking_date, index: true

      t.timestamps null: false
    end
    add_foreign_key :booking_times, :booking_dates
  end
end
