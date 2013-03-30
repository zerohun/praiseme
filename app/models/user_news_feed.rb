class UserNewsFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_feed

  def take_score_from_news_feed
    score = self.news_feed.score
    user = self.user
    user_stamps = user.user_stamps.where(:stamp_id => news_feed.notifiable.stamp_id)
    if user_stamps.present?
      user_stamp = user_stamps.first
      user_stamp.exp += score
      after_exp = user_stamp.exp
      if user_stamp.save
        self.update_attribute :score_taken, true
      end
      return after_exp
    end
  end
end
