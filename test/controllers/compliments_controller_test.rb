require 'test_helper'
require 'controller_test_helper'

class ComplimentsControllerTest < ActionController::TestCase
  setup do
    @compliment = compliments(:one)
    sign_in users(:zerohun)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compliments)
  end

  test "should get new" do
    get :new, compliment: { receiver_id: 1, sender_id: 2, stamp_id: 1 }
    assert_response :success
  end

  test "should create compliment" do
    assert_difference('Compliment.count') do
      post :create, compliment: { description: @compliment.description, receiver_id: users(:sheldon).id, sender_id: users(:penny).id, stamp_id: @compliment.stamp_id }
    end

    assert_redirected_to compliment_path(assigns(:compliment))
  end

  test "should show compliment" do
    get :show, id: @compliment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compliment, sender_id: 1, receiver_id: 1
    assert_response :success
  end

  test "should update compliment" do
    patch :update, id: @compliment, compliment: { description: @compliment.description, receiver_id: @compliment.receiver_id, sender_id: @compliment.sender_id, stamp_id: @compliment.stamp_id }
    assert_redirected_to compliment_path(assigns(:compliment))
  end

  test "should destroy compliment" do
    assert_difference('Compliment.count', -1) do
      delete :destroy, id: @compliment
    end

    assert_redirected_to compliments_path
  end
end
