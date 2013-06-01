class CreateDefaultTrophyImages < ActiveRecord::Migration
  def change
    create_table :default_trophy_images do |t|
      t.string :file
      t.integer :image_type

      t.timestamps
    end
  end
end
