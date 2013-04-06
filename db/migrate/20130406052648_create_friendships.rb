class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :is_invited_by, index: true
      t.references :has_invited, index: true
      t.integer :status

      t.timestamps
    end
  end
end
