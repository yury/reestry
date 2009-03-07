require 'test_helper'

class ListFieldValuesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:list_field_values)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_list_field_value
    assert_difference('ListFieldValue.count') do
      post :create, :list_field_value => { }
    end

    assert_redirected_to list_field_value_path(assigns(:list_field_value))
  end

  def test_should_show_list_field_value
    get :show, :id => list_field_values(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => list_field_values(:one).id
    assert_response :success
  end

  def test_should_update_list_field_value
    put :update, :id => list_field_values(:one).id, :list_field_value => { }
    assert_redirected_to list_field_value_path(assigns(:list_field_value))
  end

  def test_should_destroy_list_field_value
    assert_difference('ListFieldValue.count', -1) do
      delete :destroy, :id => list_field_values(:one).id
    end

    assert_redirected_to list_field_values_path
  end
end
