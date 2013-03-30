class UserStamp < ActiveRecord::Base

  default_scope {includes(:user, :stamp)}

  belongs_to :stamp
  belongs_to :user

  GROWTH_RATE = 1.2
  EXP_MULTIPLE_NUMBER = 100
  IMPACT_MULTIPLE_NUMBER = 10


  before_save do |user_stamp|
    if self.exp >= self.exp_to_level_up
      user_stamp.exp -= self.exp_to_level_up
      user_stamp.level += 1

      news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:level_up]
      compliment_user_ids = user_stamp.user.sent_compliments.where(:stamp_id => user_stamp.stamp_id).map {|compliment| compliment.receiver_id}
      user_stamp.user.followers.where("users.id not in (?)", compliment_user_ids).each do |follower|
        follower.user_news_feeds.create :new_feed => news_feed
      end

      score_news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:level_up], :score => user_stamp.levelup_impact
      User.where(:id => compliment_user_ids).each do |follower|
        follower.user_news_feeds.create :news_feed => score_news_feed
      end
    end
  end

  def complimeted_stamps
    compliments = Compliment.where :sender_id => self.user_id, :stamp_id => self.stamp_id
    receiver_ids = compliments.map {|compliment|
      compliment.receiver_id
    }
    UserStamp.where(:user_id => receiver_ids, :stamp_id => self.stamp_id)
  end

  def exp_to_level_up
    (formular(self.level) * EXP_MULTIPLE_NUMBER).floor
  end

  def impact
    (formular(self.level) * IMPACT_MULTIPLE_NUMBER).floor
  end

  def previous_impact
    (formular(self.level - 1) * IMPACT_MULTIPLE_NUMBER).floor
  end

  def levelup_impact
    impact - previous_impact
  end

  def exp_to_percent
    (self.exp.to_f / self.exp_to_level_up.to_f * 100.0).round(0)
  end

  private

  def formular(level)
    GROWTH_RATE ** level
  end

end
