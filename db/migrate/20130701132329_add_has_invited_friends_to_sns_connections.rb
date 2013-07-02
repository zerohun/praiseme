class AddHasInvitedFriendsToSnsConnections < ActiveRecord::Migration
  def change
    add_column :sns_connections, :has_invited_friends, :boolean, :default => false
  end
end
