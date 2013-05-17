class AddJobAndSchoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job, :string
    add_column :users, :school, :string
  end
end
