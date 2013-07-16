class ChangeIntroduceFromStringToTextInUsers < ActiveRecord::Migration
  def up
    change_column :users, :introduce, :text
  end

  def down
    change_column :users, :introduce, :string
  end
end
