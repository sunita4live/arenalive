class CreateBookingDates < ActiveRecord::Migration
  def change
    create_table :booking_dates do |t|
      t.date :date_of_booking
      t.boolean :status
      t.references :ground, index: true

      t.timestamps null: false
    end
    add_foreign_key :booking_dates, :grounds
  end
end
