require 'test_helper'

class UserProfilesControllerTest < ActionController::TestCase

  test "should get index" do
    sign_in users(:zerohun)
    get :index
    assert_response :success
  end

  test "should get show" do
    sign_in users(:zerohun)
    get :show, :id => users(:zerohun).id
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:zerohun)
    get :index
    assert_response :success
  end

end
