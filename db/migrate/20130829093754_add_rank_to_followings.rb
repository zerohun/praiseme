class AddRankToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :rank, :integer
  end
end
