require 'test_helper'

class UserProfilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, :id => users(:zerohun).id
    assert_response :success
  end

end
