class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.references :notifiable, index: true
      t.string :notifiable_type
      t.integer :action
      t.integer :score, :default => 0
      t.timestamps
    end
  end
end
