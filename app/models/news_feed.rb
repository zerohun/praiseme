class NewsFeed < ActiveRecord::Base

  default_scope {includes(:notifiable)}

  has_many :user_news_feeds
  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3,
    :score_up => 4,
    :rank_up => 5
  }

  def self.create_for_compliment(compliment)
    news_feed = NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create]
    sender = news_feed.notifiable.sender
    receiver = news_feed.notifiable.receiver
    news_feed.notify_to sender
    news_feed.notify_to receiver
    news_feed.notify_to sender.followers.where.not(:id => receiver.id)
    news_feed.notify_to receiver.followers.where.not(:id => sender.id)
    news_feed
  end

  def self.create_for_jumping_score(user_stamp)
    news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:score_up]
    user_ids = user_stamp.complimented_stamps.map {|us| us.user_id }.uniq
    user_ids.each do |user_id|
      UserNewsFeed.create :user_id => user_id, :news_feed => news_feed
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

    if self.notifiable_type == "UserStamp" && self.action_type == :score_up
      user = self.notifiable.user
      stamp = self.notifiable.stamp
      return "#{user.username}'s getting a good reputation on #{stamp.title} these day. #{user.username} have complimented you on #{stamp.title} before. you also deserve good reputation too. (+10)"
    end
  end

  def notify_to(users)
    if users.class == User
      one_user = users
      one_user.user_news_feeds.create :news_feed => self
    elsif users == ActiveRecord::Relation::ActiveRecord_Relation_User
      users.find_each do |user|
        user.ser_news_feeds.create :news_feed => self
      end
    end
  end
end
