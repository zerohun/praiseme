class CreateUserStamps < ActiveRecord::Migration
  def change
    create_table :user_stamps do |t|
      t.references :stamp, index: true
      t.references :user, index: true
      t.integer :exp, :default => 0
      t.integer :level, :default => 1

      t.timestamps
    end
  end
end
