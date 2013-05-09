require 'test_helper'

class UserStampTest < ActiveSupport::TestCase
  test "should notify level up" do
    user_stamp = user_stamps(:one)
    assert_difference "NewsFeed.where(:notifiable_type => 'UserStamp').count" do
      user_stamp.score = user_stamp.score + 100
      user_stamp.save
    end

    assert_difference "user_stamp.complimented_stamps.first.score", 7 do
      user_stamp.score = user_stamp.score + 100
      user_stamp.save
    end
  end

  #test "notitfy when a user gaiend rank" do
    #user_stamp = user_stamps(:one)
    #user_stamp.update_attributes :rank => 2, :score => 0
    #assert_difference "NewsFeed.count"  do
      #user_stamp.score = 10000
      #user_stamp.save
    #end
  #end

  test "create_user_stamp with news_feed" do
    assert_difference "NewsFeed.count"  do
      UserStamp.create :user_id => 1, :stamp_id => 3
    end
  end
end
