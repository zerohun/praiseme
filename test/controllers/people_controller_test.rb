require 'test_helper'
require 'controller_test_helper'

class PeopleControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in users(:zerohun)
    get :index
    assert_response :success
  end

end
