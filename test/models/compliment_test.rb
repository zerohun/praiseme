require 'test_helper'

class ComplimentTest < ActiveSupport::TestCase
   test "should create with essential attributes and news feed" do
     assert_difference "Compliment.count" do
       compliment = Compliment.new :sender_id => users(:penny).id, :receiver_id => users(:sheldon).id, :stamp_id => stamps(:programming).id
       compliment.save
     end
   end

   test "should create with news feed" do
     assert_difference "NewsFeed.where(:notifiable_type => 'Compliment').count" do
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

  test "is_destroyable_by? should return true for sender" do
    compliment = compliments(:one)
    assert compliment.is_destroyable_by?(users(:zerohun))
  end

  test "is_destroyable_by? should return true for receiver" do
    compliment = compliments(:one)
    assert compliment.is_destroyable_by?(users(:sarah))
  end

  test "is_destroyable_by? should return true for soneone elae" do
    compliment = compliments(:one)
    assert compliment.is_destroyable_by?(users(:sheldon)) == false
  end
end
