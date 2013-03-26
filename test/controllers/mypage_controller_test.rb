require 'test_helper'

class MypageControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in users(:zerohun)
    get :index
    assert_response :success
  end

end
