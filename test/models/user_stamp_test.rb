require 'test_helper'

class UserStampTest < ActiveSupport::TestCase
   setup do 
     @user_stamp = user_stamps(:one)
   end

   test "should level up when it got enough exp" do
     assert_difference("@user_stamp.level") do
       @user_stamp.exp += @user_stamp.exp_to_level_up
       @user_stamp.save
     end
   end

   test "should notify followers and complimented after level up" do
     assert_difference "UserNewsFeed.count", (@user_stamp.user.followers.count + @user_stamp.complimeted_stamps.count) do
       @user_stamp.exp += @user_stamp.exp_to_level_up
       @user_stamp.save
     end
     news_feed = NewsFeed.where(:notifiable_type => "UserStamp", :notifiable_id => @user_stamp.id).where("score > 0").first
     assert news_feed.score == @user_stamp.levelup_impact
   end
end
