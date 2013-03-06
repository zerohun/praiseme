require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "password should not required when user's sns_connection is exist" do
    u = User.new(:email => "blient@naver.com")
    u.sns_connections.new :provider => "facebook", :uid => "123123123"
    assert not(u.password_required?)
   end

  test "should be able to update user's information when the user deosn't have any password" do
    u = users(:zerohun)
    u.update_with_password :email => "blient@naver.com"
    assert u.email == "blient@naver.com"
  end
end
