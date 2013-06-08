class CreateSearchKeywords < ActiveRecord::Migration
  def change
    create_table :search_keywords do |t|
      t.string :text
      t.integer :priority
      t.references :target, index: true
      t.string :target_type
    end
  end
end
