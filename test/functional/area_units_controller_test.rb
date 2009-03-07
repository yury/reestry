require 'test_helper'

class AreaUnitsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:area_units)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_area_unit
    assert_difference('AreaUnit.count') do
      post :create, :area_unit => { }
    end

    assert_redirected_to area_unit_path(assigns(:area_unit))
  end

  def test_should_show_area_unit
    get :show, :id => area_units(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => area_units(:one).id
    assert_response :success
  end

  def test_should_update_area_unit
    put :update, :id => area_units(:one).id, :area_unit => { }
    assert_redirected_to area_unit_path(assigns(:area_unit))
  end

  def test_should_destroy_area_unit
    assert_difference('AreaUnit.count', -1) do
      delete :destroy, :id => area_units(:one).id
    end

    assert_redirected_to area_units_path
  end
end
