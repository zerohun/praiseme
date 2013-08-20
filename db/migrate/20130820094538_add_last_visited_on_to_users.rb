class AddLastVisitedOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_visited_on, :date
  end
end
