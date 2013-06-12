require 'test_helper'
require 'controller_test_helper'

class Admin::DefaultTrophyImagesControllerTest < ActionController::TestCase
  setup do
    @admin_default_trophy_image = default_trophy_images(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:default_trophy_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_default_trophy_image" do
    assert_difference('DefaultTrophyImage.count') do
      post :create, default_trophy_image: {:file => blank_image}
    end

    assert_redirected_to admin_default_trophy_image_path(assigns(:default_trophy_image))
  end

  test "should show admin_default_trophy_image" do
    get :show, id: @admin_default_trophy_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_default_trophy_image
    assert_response :success
  end

  test "should update admin_default_trophy_image" do
    patch :update, id: @admin_default_trophy_image, default_trophy_image: {:file => blank_image }
    assert_redirected_to admin_default_trophy_image_path(assigns(:default_trophy_image))
  end

  test "should destroy admin_default_trophy_image" do
    assert_difference('DefaultTrophyImage.count', -1) do
      delete :destroy, id: @admin_default_trophy_image
    end

    assert_redirected_to admin_default_trophy_images_path
  end
end
