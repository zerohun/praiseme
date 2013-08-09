class AddIsPostToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :is_post, :integer, :default => 0
  end
end
