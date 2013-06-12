class AddIsGoingToBeRemovedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_going_to_be_removed, :boolean
  end
end
