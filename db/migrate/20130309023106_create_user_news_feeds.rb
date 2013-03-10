class CreateUserNewsFeeds < ActiveRecord::Migration
  def change
    create_table :user_news_feeds do |t|
      t.references :user, index: true
      t.references :news_feed, index: true
      t.boolean :is_read

      t.timestamps
    end
  end
end
