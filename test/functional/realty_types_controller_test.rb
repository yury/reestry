require 'test_helper'

class RealtyTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:realty_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_realty_type
    assert_difference('RealtyType.count') do
      post :create, :realty_type => { }
    end

    assert_redirected_to realty_type_path(assigns(:realty_type))
  end

  def test_should_show_realty_type
    get :show, :id => realty_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => realty_types(:one).id
    assert_response :success
  end

  def test_should_update_realty_type
    put :update, :id => realty_types(:one).id, :realty_type => { }
    assert_redirected_to realty_type_path(assigns(:realty_type))
  end

  def test_should_destroy_realty_type
    assert_difference('RealtyType.count', -1) do
      delete :destroy, :id => realty_types(:one).id
    end

    assert_redirected_to realty_types_path
  end
end
