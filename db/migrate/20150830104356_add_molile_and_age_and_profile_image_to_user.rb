class AddMolileAndAgeAndProfileImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :mobile, :string
    add_column :users, :age, :integer
    add_column :users, :profile_image, :string
  end
end
