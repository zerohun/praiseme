require 'test_helper'
require 'controller_test_helper'

class FollowingsControllerTest < ActionController::TestCase
  setup do
    @following = followings(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index, :user_profile_id => 1
    assert_response :success
  end

  test "should create following" do
    assert_difference('Following.count') do
      post :create, following: { followee_id: @following.followee_id, follower_id: @following.follower_id }, format: "js"
    end

  end

  test "should destroy following" do
    assert_difference('Following.count', -1) do
      delete :destroy, id: @following, format: "js"
    end
  end
end
