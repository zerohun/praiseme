require 'test_helper'

class FollowingsControllerTest < ActionController::TestCase
  setup do
    @following = followings(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:followings)
  end

  test "should create following" do
    assert_difference('Following.count') do
      post :create, following: { followee_id: @following.followee_id, follower_id: @following.follower_id, format: "json" }
    end

    assert_redirected_to following_path(assigns(:following))
  end

  test "should destroy following" do
    assert_difference('Following.count', -1) do
      delete :destroy, id: @following, format: "json"
    end
  end
end
