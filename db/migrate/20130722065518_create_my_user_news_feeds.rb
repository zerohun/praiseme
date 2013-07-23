class CreateMyUserNewsFeeds < ActiveRecord::Migration
  def change
    create_table :my_user_news_feeds do |t|
      t.references :user, index: true
      t.references :news_feed, index: true

      t.timestamps
    end
  end
end
