class NewsFeed < ActiveRecord::Base
  
  default_scope {includes(:notifiable)}

  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3,
    :level_up => 4
  }

  def action_type
    ACTION_TYPE.key(self.action)
  end

  def to_s
    if self.notifiable_type == "Compliment" && self.action_type == :create
      return "#{self.notifiable.sender.username} gave stamp of #{self.notifiable.stamp.title} to #{self.notifiable.receiver.username}"
    end

    if self.notifiable_type == "User" && self.action_type == :create
      return "#{self.notifiable.username} has joined"
    end

    if self.notifiable_type == "UserStamp" && self.action_type == :level_up
      user = self.notifiable.user
      stamp = self.notifiable.stamp
      return "#{user.username}'s #{stamp.title} level up"
    end
  end

  def notify_to_followers_of(user)
    user.followers.each do |follower|
      follower.user_news_feeds.create :news_feed => news_feed
    end
  end
end
