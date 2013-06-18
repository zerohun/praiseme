require 'test_helper'

class CommentTest < ActiveSupport::TestCase
   test "is_destroyable_by? should return true for author as parameter" do
     comment = comments(:one)
     assert comment.is_destroyable_by?(users(:zerohun))
   end

   test "User can destroy comments written by someone else for compliment he receivedk" do
     comment = comments(:two)
     assert comment.is_destroyable_by?(users(:zerohun))
   end

   test "Userc can't delete someonse elses comment that doesn't belongs to his compliment"  do
     comment = comments(:three)
     assert comment.is_destroyable_by?(users(:zerohun)) == false
   end

end
