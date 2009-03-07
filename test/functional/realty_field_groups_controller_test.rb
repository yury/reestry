require 'test_helper'

class RealtyFieldGroupsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:realty_field_groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_realty_field_groups
    assert_difference('RealtyFieldGroups.count') do
      post :create, :realty_field_groups => { }
    end

    assert_redirected_to realty_field_groups_path(assigns(:realty_field_groups))
  end

  def test_should_show_realty_field_groups
    get :show, :id => realty_field_groups(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => realty_field_groups(:one).id
    assert_response :success
  end

  def test_should_update_realty_field_groups
    put :update, :id => realty_field_groups(:one).id, :realty_field_groups => { }
    assert_redirected_to realty_field_groups_path(assigns(:realty_field_groups))
  end

  def test_should_destroy_realty_field_groups
    assert_difference('RealtyFieldGroups.count', -1) do
      delete :destroy, :id => realty_field_groups(:one).id
    end

    assert_redirected_to realty_field_groups_path
  end
end
