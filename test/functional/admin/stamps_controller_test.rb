require 'test_helper'

class Admin::StampsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Stamp.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Stamp.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Stamp.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to admin_stamp_url(assigns(:stamp))
  end

  def test_edit
    get :edit, :id => Stamp.first
    assert_template 'edit'
  end

  def test_update_invalid
    Stamp.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Stamp.first
    assert_template 'edit'
  end

  def test_update_valid
    Stamp.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Stamp.first
    assert_redirected_to admin_stamp_url(assigns(:stamp))
  end

  def test_destroy
    stamp = Stamp.first
    delete :destroy, :id => stamp
    assert_redirected_to admin_stamps_url
    assert !Stamp.exists?(stamp.id)
  end
end
