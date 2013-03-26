require 'test_helper'
require 'controller_test_helper'

class MainControllerTest < ActionController::TestCase
  setup do
    sign_in users(:zerohun)
  end
  test "should get index" do
    get :index
    assert_response :success
  end

end
