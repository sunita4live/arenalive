class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user, index: true
      t.boolean :cancel

      t.timestamps null: false
    end
    add_foreign_key :bookings, :users
  end
end
