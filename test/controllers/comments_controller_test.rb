require 'test_helper'
require 'controller_test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:zerohun)
  end
  test "should create" do
    assert_difference "Comment.count" do
      get :create, :compliment_id => 1, :comment => {:content => "this is comment"}, :format => :js
    end
    assert_response :success
    assert_template :create
  end
end
