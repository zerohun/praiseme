require 'test_helper'

class SnsConnectionsControllerTest < ActionController::TestCase
  test "should get find_friends" do
    get :find_friends
    assert_response :success
  end

end
