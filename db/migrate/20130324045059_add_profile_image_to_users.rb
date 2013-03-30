class AddProfileImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :facebook_image_url, :string
  end
end
