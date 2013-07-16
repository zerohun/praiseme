class NotifierForNewUsersFollowersWorker
  include Sidekiq::Worker
  def perform(news_feed_id, user_id)
    news_feed = NewsFeed.find(news_feed_id)
    user = User.find(user_id)
    news_feed.notify_to user.followers
  end
end
