ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def blank_image
    Rack::Test::UploadedFile.new(Rails.root.join('public/images_for_test/test.png'), 'image/png')
  end  
  
  

  # Add more helper methods to be used by all tests here...
end
