class ChangeIntroduceFromStringToTextInUsers < ActiveRecord::Migration
  def change
    change_column :users, :introduce, :text
  end
end
