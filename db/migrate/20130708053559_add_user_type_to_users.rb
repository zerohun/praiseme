class AddUserTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_admin_type, :integer , :default => 0
    add_column :users, :is_blocked, :boolean, :default => false
    
  end
end
