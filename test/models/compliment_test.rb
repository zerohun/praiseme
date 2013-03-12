require 'test_helper'

class ComplimentTest < ActiveSupport::TestCase
   test "should create with essential attributes and news feed" do
     assert_difference "Compliment.count" do
       compliment = Compliment.new :sender_id => users(:zerohun).id, :receiver_id => users(:sarah).id, :stamp_id => stamps(:art).id
       assert_difference "NewsFeed.count" do
         compliment.save
       end
     end
   end

  test "shouldn't let user complimdng him/herself" do
    assert_no_difference "Compliment.count" do
      compliment = Compliment.new :sender_id => users(:zerohun).id, :receiver_id => users(:sarah).id, :stamp_id => stamps(:art).id
      compliment.save
    end

  end
end
