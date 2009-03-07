require 'test_helper'

class RealtyFieldsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:realty_fields)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_realty_field
    assert_difference('RealtyField.count') do
      post :create, :realty_field => { }
    end

    assert_redirected_to realty_field_path(assigns(:realty_field))
  end

  def test_should_show_realty_field
    get :show, :id => realty_fields(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => realty_fields(:one).id
    assert_response :success
  end

  def test_should_update_realty_field
    put :update, :id => realty_fields(:one).id, :realty_field => { }
    assert_redirected_to realty_field_path(assigns(:realty_field))
  end

  def test_should_destroy_realty_field
    assert_difference('RealtyField.count', -1) do
      delete :destroy, :id => realty_fields(:one).id
    end

    assert_redirected_to realty_fields_path
  end
end
