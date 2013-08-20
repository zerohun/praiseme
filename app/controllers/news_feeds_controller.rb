class NewsFeedsController < ApplicationController
  # GET /news_feeds
  # GET /news_feeds.json
  def index
    @news_feeds = current_user.news_feeds.group("news_feeds.id").select("*")

    @news_feeds = @news_feeds.page(params[:page]).per(15)
    unread_news_feed_ids = @news_feeds.map {|new_feed| new_feed.id}
    current_user.user_news_feeds.where(:news_feed_id => unread_news_feed_ids).where(:is_read => false).update_all(:is_read => true)
  end

end 
