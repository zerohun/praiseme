require 'test_helper'

class Admin::ComplimentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Compliment.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Compliment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Compliment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to admin_compliment_url(assigns(:compliment))
  end

  def test_edit
    get :edit, :id => Compliment.first
    assert_template 'edit'
  end

  def test_update_invalid
    Compliment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Compliment.first
    assert_template 'edit'
  end

  def test_update_valid
    Compliment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Compliment.first
    assert_redirected_to admin_compliment_url(assigns(:compliment))
  end

  def test_destroy
    compliment = Compliment.first
    delete :destroy, :id => compliment
    assert_redirected_to admin_compliments_url
    assert !Compliment.exists?(compliment.id)
  end
end
