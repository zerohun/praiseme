class CreateStampSuggestions < ActiveRecord::Migration
  def change
    create_table :stamp_suggestions do |t|
      t.string :name
      t.integer :popularity

      t.timestamps
    end
  end
end
