class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :target, index: true
      t.references :user, index: true
      t.string :target_type
      t.text :content

      t.timestamps
    end
  end
end
