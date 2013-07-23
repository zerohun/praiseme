class MyUserNewsFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_feed


  def self.create_new_my_user_feed(news_feed)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.id, :news_feed_id => news_feed.id)
  end

  def self.create_new_my_compliment_feed(news_feed)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.sender_id, :news_feed_id => news_feed.id)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.receiver_id, :news_feed_id => news_feed.id)
  end  

  def self.create_new_my_jump_score_feed(news_feed)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.user_id, :news_feed_id => news_feed.id)
  end

  def self.create_new_my_rank_feed(news_feed)
  #  MyUserNewsFeed.create(:user_id => news_feed.notifiable.user_id, :news_feed_id => news_feed.id)
  end
  
  def self.create_new_my_stamp_feed(news_feed)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.user_id, :news_feed_id => news_feed.id)
  end
  
  def self.create_new_my_comment_feed(news_feed)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.target.sender_id, :news_feed_id => news_feed.id)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.target.receiver_id, :news_feed_id => news_feed.id)
    MyUserNewsFeed.create(:user_id => news_feed.notifiable.user.id , :news_feed_id => news_feed.id)
  end
end
