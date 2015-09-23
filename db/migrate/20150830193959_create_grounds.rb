class CreateGrounds < ActiveRecord::Migration
  def change
    create_table :grounds do |t|
      t.string :name
      t.string :city
      t.text :area
      t.string :pincode
      t.text :address
      t.string :status
      t.string :category
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :grounds, :users
  end
end
