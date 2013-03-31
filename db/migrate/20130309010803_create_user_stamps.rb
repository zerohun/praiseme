class CreateUserStamps < ActiveRecord::Migration
  def change
    create_table :user_stamps do |t|
      t.references :stamp, index: true
      t.references :user, index: true
      t.integer :score, :default => 10
      t.integer :rank
      t.integer :previous_rank
      t.timestamps
    end
  end
end
