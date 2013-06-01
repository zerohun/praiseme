class AddDefaultTrophyImageIdToStamps < ActiveRecord::Migration
  def change
    add_column :stamps, :default_trophy_image_id, :integer
    add_index :stamps, :default_trophy_image_id
  end
end
