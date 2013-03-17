require 'test_helper'

class ComplimentTest < ActiveSupport::TestCase
   test "should create with essential attributes and news feed" do
     assert_difference "Compliment.count" do
       compliment = Compliment.new :sender_id => users(:penny).id, :receiver_id => users(:sheldon).id, :stamp_id => stamps(:programming).id
       compliment.save
     end
   end

   test "should create with news feed" do
     assert_difference "NewsFeed.count", 2 do
       compliment = Compliment.new :sender_id => users(:penny).id, :receiver_id => users(:sheldon).id, :stamp_id => stamps(:programming).id
       compliment.save
     end
   end

  test "shouldn't let user complimdng him/herself" do
    assert_no_difference "Compliment.count" do
      compliment = Compliment.new :sender_id => users(:sarah).id, :receiver_id => users(:sarah).id, :stamp_id => stamps(:art).id
      compliment.save
    end
  end

  test "shouldn't make duplicate compliment" do
    compliment = Compliment.new :sender_id => users(:sarah).id, :receiver_id => users(:penny).id, :stamp_id => stamps(:art).id
    compliment.save
    assert_no_difference "Compliment.count" do
      compliment = Compliment.new :sender_id => users(:sarah).id, :receiver_id => users(:penny).id, :stamp_id => stamps(:art).id
      compliment.save
    end
  end
end
