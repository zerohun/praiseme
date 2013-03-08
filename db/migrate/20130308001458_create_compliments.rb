class CreateCompliments < ActiveRecord::Migration
  def change
    create_table :compliments do |t|
      t.integer :sender_id, index: true
      t.integer :receiver_id, index: true
      t.references :stamp, index: true
      t.text :description

      t.timestamps
    end
  end
end
