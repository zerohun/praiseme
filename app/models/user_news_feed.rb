class UserNewsFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_feed

  def take_score_from_news_feed
    score = self.news_feed.score
    user_stamp = current_user.user_stamps.where :stamp_id => new_feed.notifiable.stamp_id
    user_stamp.exp += score
    user_stamp.save
  end
end
