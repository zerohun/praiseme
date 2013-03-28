require 'test_helper'

class SnsConnectionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:zerohun)
  end
  test "should get find_friends" do
    get :find_friends
    assert_response :success
  end

end
