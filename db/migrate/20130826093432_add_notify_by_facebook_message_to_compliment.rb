class AddNotifyByFacebookMessageToCompliment < ActiveRecord::Migration
  def change
    add_column :compliments, :notify_by_facebook_message, :boolean
  end
end
