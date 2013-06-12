class AddIsGoingToBeRemovedToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :is_going_to_be_removed, :boolean
  end
end
