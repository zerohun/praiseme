require 'test_helper'
require 'controller_test_helper'

class NewsFeedsControllerTest < ActionController::TestCase
  setup do
    @news_feed = news_feeds(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_feeds)
    assert user_news_feeds(:one).is_read == true

  end
end
