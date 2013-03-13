class NewsFeed < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3
  }

  after_create do |new_feed|
    if new_feed.notifiable_type == "Compliment" && new_feed.action_type == :create
      new_feed.followers.each do |follower|
        follower.user_news_feeds.create :new_feed => new_feed
      end
    end

  end

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
  end
end
