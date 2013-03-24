class CreateStamps < ActiveRecord::Migration
  def change
    create_table :stamps do |t|
      t.string :title
      t.text :description
      t.integer :used_count
      t.boolean :is_blocked

      t.string :image

      t.timestamps
    end
  end
end
