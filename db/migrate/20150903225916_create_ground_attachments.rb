class CreateGroundAttachments < ActiveRecord::Migration
  def change
    create_table :ground_attachments do |t|
      t.integer :ground_id
      t.string :photo

      t.timestamps null: false
    end
  end
end
