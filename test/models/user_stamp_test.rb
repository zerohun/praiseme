require 'test_helper'

class UserStampTest < ActiveSupport::TestCase
  test "when score is over the 100 it has to notify and give score to another user_stamps which got compliment from it" do
    user_stamp = user_stamps(:one)
    assert_difference "NewsFeed.count" do
      user_stamp.score = user_stamp.score + 100
      user_stamp.save
    end

    assert_difference "user_stamp.complimented_stamps.first.score", 10 do
      user_stamp.score = user_stamp.score + 100
      user_stamp.save
    end
  end


end
