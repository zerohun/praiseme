class NewsFeedsController < ApplicationController
  # GET /news_feeds
  # GET /news_feeds.json
  def index
    @news_feeds = current_user.news_feeds
    @news_feeds = @news_feeds.page(params[:page]).per(15)
    unread_news_feed_ids = @news_feeds.map {|new_feed| new_feed.id}
    current_user.user_news_feeds.where(:news_feed_id => unread_news_feed_ids).where(:is_read => false).update_all(:is_read => true)
  end

  def get_score
    @news_feed = NewsFeed.find(params[:id])
    user_news_feed = @news_feed.user_news_feeds.where(:user_id => current_user.id).first
    user_news_feed.take_score_from_news_feed
    exp_to_percent = user_news_feed.user.user_stamps.where(:stamp_id => @news_feed.notifiable.stamp.id).first.exp_to_percent
    render :json => {:exp_to_percent => exp_to_percent}
  end
end 
