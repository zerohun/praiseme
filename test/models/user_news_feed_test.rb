require 'test_helper'

class UserNewsFeedTest < ActiveSupport::TestCase
   test "should get score from news feed" do
     user_news_feed = user_news_feeds(:three)
     news_feed = user_news_feed.news_feed
     user_stamp = news_feed.notifiable
     assert_difference "UserStamp.where(:user_id => user_news_feed.user_id, :stamp_id => user_stamp.stamp_id).first.exp", news_feed.score do 
       user_news_feed.take_score_from_news_feed
     end
   end
end
