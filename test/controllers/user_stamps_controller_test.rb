require 'test_helper'

class UserStampsControllerTest < ActionController::TestCase
  setup do
    @user_stamp = user_stamps(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_stamps)
  end

  test "should get new" do
    get :new, user_stamp: { score: @user_stamp.score, stamp_id: @user_stamp.stamp_id, user_id: @user_stamp.user_id }
    assert_response :success
  end

  test "should create user_stamp" do
    assert_difference('UserStamp.count') do
      post :create, user_stamp: { score: @user_stamp.score, stamp_id: @user_stamp.stamp_id, user_id: @user_stamp.user_id }
    end

    assert_redirected_to user_stamp_path(assigns(:user_stamp))
  end

  test "should show user_stamp" do
    get :show, id: @user_stamp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_stamp
    assert_response :success
  end

  test "should update user_stamp" do
    patch :update, id: @user_stamp, user_stamp: { score: @user_stamp.score, stamp_id: @user_stamp.stamp_id, user_id: @user_stamp.user_id }
    assert_redirected_to user_stamp_path(assigns(:user_stamp))
  end

  test "should destroy user_stamp" do
    assert_difference('UserStamp.count', -1) do
      delete :destroy, id: @user_stamp
    end

    assert_redirected_to user_stamps_path
  end
end
