class NewsFeed < ActiveRecord::Base

  default_scope {includes(:notifiable).order("news_feeds.id desc")}

  has_many :user_news_feeds, :dependent => :destroy
  has_many :my_user_news_feeds, :dependent => :destroy

  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3,
    :score_up => 4,
    :rank_up => 5
  }

  def self.create_for_new_user(user)
    news_feed = NewsFeed.create :notifiable => user, :action => NewsFeed::ACTION_TYPE[:create]
    news_feed.notify_to user
    NotifierForNewUsersFollowersWorker.perform_async news_feed.id, user.id
    MyUserNewsFeed.delay.create_new_my_user_feed news_feed
  end

  def self.create_for_compliment(compliment)
    news_feed = newsfeed.create :notifiable => compliment, :action => newsfeed::action_type[:create]
    sender = news_feed.notifiable.sender
    receiver = news_feed.notifiable.receiver
    news_feed.notify_to sender
    news_feed.notify_to receiver
    senders_followers = sender.followers.where.not(:id => receiver.id)
    senders_follower_ids = senders_followers.pluck(:id)
    news_feed.notify_to senders_followers
    news_feed.notify_to receiver.followers.where.not(:id => sender.id).where.not(:id => senders_follower_ids)
   
    MyUserNewsFeed.delay.create_new_my_compliment_feed news_feed

    news_feed
  end

  def self.create_for_jumping_score(user_stamp)
    news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:score_up]
    news_feed.notify_to user_stamp.user
    news_feed.notify_to user_stamp.user.followers
    MyUserNewsFeed.delay.create_new_my_jump_score_feed news_feed
  end

  def self.create_for_gainig_rank(user_stamp)
    news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:rank_up]
    news_feed.notify_to user_stamp.user
    MyUserNewsFeed.delay.create_new_my_rank_feed news_feed
  end


  def self.create_for_new_user_stamp(user_stamp)
    news_feed = NewsFeed.create :notifiable => user_stamp, :action => NewsFeed::ACTION_TYPE[:create]
    news_feed.notify_to user_stamp.user
    news_feed.notify_to user_stamp.user.followers
    MyUserNewsFeed.delay.create_new_my_stamp_feed news_feed
  end

  def self.create_for_new_comment(comment)
    news_feed = NewsFeed.create :notifiable => comment, :action => NewsFeed::ACTION_TYPE[:create]
    news_feed.notify_to comment.user
    news_feed.notify_to comment.user.followers
    MyUserNewsFeed.delay.create_new_my_comment_feed news_feed
  end
  
  def action_type
    ACTION_TYPE.key(self.action)
  end

  def to_s
    if self.notifiable_type == "Compliment" && self.action_type == :create
      return "#{self.notifiable.sender.username} thinks #{self.notifiable.receiver.username} #{self.notifiable.stamp.verb} #{self.notifiable.stamp.title}(+#{self.notifiable.impact_score})"
    end

    if self.notifiable_type == "User" && self.action_type == :create
      return "#{self.notifiable.username} has joined"
    end

    if self.notifiable_type == "UserStamp"
      if self.action_type == :score_up
        user = self.notifiable.user
        stamp = self.notifiable.stamp
        return " #{user.username}'s '#{stamp.title}' level is #{self.notifiable.level} now!"
      elsif self.action_type == :rank_up
        user_stamp = self.notifiable
        stamp = self.notifiable.stamp
        return "Your #{stamp.title}'s rank is #{user_stamp.rank} now (up #{ user_stamp.previous_rank - user_stamp.rank})"
      elsif self.action_type == :create
        user = self.notifiable.user
        stamp = self.notifiable.stamp
        return "#{user.username} got #{stamp.title} for first time!!"
      end
    end
    
    if self.notifiable_type == "Comment" && self.action_type == :create
      return "#{self.notifiable.user.username} commented on #{self.notifiable.target.receiver.username}'s \"#{self.notifiable.target.stamp.title}\" glory  "
    end

  end

  def notify_to(users)
    if users.class == User
      one_user = users
      one_user.user_news_feeds.create :news_feed => self
    elsif users.class == ActiveRecord::Relation::ActiveRecord_Relation_User || users.class == ActiveRecord::Associations::CollectionProxy::ActiveRecord_Associations_CollectionProxy_User
      users.find_each do |user|
        user.user_news_feeds.create :news_feed => self
      end
    end
  end
end
