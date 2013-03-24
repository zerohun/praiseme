class Compliment < ActiveRecord::Base

  default_scope {includes(:sender, :receiver, :stamp)}

  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp

  validate :shoundnt_compliment_himself
  validates_uniqueness_of :sender_id, :scope => [:receiver_id, :stamp_id]

  after_create do |compliment|
    news_feed = NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create]
    news_feed.notifiable.sender.followers.where("users.id != ?", news_feed.notifiable.receiver.id).each do |follower|
      follower.user_news_feeds.create :news_feed => news_feed
    end
    user_stamp = compliment.receiver.user_stamps.find_or_create_by(:stamp_id => compliment.stamp.id)
    stamp_id = user_stamp.stamp_id
    user_stamp = compliment.sender.user_stamps.find_by(:stamp_id => stamp_id)
    if user_stamp.present?
      getting_score = user_stamp.impact
    else
      getting_score = 10
    end
    news_feed_for_receiver = NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create], :score => getting_score
    compliment.receiver.user_news_feeds.create :news_feed => news_feed_for_receiver
  end
  def shoundnt_compliment_himself
    if self.sender_id == self.receiver_id
      self.errors[:sender_id] = "You can't compliment youself"
      self.errors[:receiver_id] = "You can't compliment youself"
    end
  end
end
