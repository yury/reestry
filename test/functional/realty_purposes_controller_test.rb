require 'test_helper'

class RealtyPurposesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:realty_purposes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_realty_purpose
    assert_difference('RealtyPurpose.count') do
      post :create, :realty_purpose => { }
    end

    assert_redirected_to realty_purpose_path(assigns(:realty_purpose))
  end

  def test_should_show_realty_purpose
    get :show, :id => realty_purposes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => realty_purposes(:one).id
    assert_response :success
  end

  def test_should_update_realty_purpose
    put :update, :id => realty_purposes(:one).id, :realty_purpose => { }
    assert_redirected_to realty_purpose_path(assigns(:realty_purpose))
  end

  def test_should_destroy_realty_purpose
    assert_difference('RealtyPurpose.count', -1) do
      delete :destroy, :id => realty_purposes(:one).id
    end

    assert_redirected_to realty_purposes_path
  end
end
