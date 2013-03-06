require 'test_helper'
require "mocha/setup"

class SnsConnectionTest < ActiveSupport::TestCase

  setup do
   @auth = {:provider => "facebook", :uid => "11222"}
   def @auth.provider
     self[:provider]
   end

   def @auth.uid
     self[:uid]
   end
  end

  test "should create from omniauth" do
   sns_connection = SnsConnection.from_omniauth(@auth)
   assert sns_connection.present?
  end

  test "should find from omniauth" do
   @auth[:uid] = "1027557496"
   sns_connection = SnsConnection.from_omniauth(@auth)
   assert sns_connection.present?
   assert sns_connection.id == 1
  end
end
