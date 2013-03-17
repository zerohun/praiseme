class NewsFeed < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3,
    :level_up => 4
  }

  after_create do |news_feed|

    #if news_feed.notifiable_type == "UserStamp" && news_feed.action_type == :level_up
      #user_stamp = news_feed.notifiable
      #compliment_user_ids = user_stamp.user.received_compliments.map {|compliment| compliment.sender_id}
      #user_stamp.user.followers.where("users.id not in (?)", compliment_user_ids).each do |follower|
        #follower.user_news_feeds.create :new_feed => news_feed
      #end
    #end
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

  def notify_to_followers_of(user)
    user.followers.each do |follower|
      follower.user_news_feeds.create :news_feed => news_feed
    end
  end
end
