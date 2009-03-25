require 'test_helper'

class DistrictStreetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:district_streets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_district_street
    assert_difference('DistrictStreet.count') do
      post :create, :district_street => { }
    end

    assert_redirected_to district_street_path(assigns(:district_street))
  end

  def test_should_show_district_street
    get :show, :id => district_streets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => district_streets(:one).id
    assert_response :success
  end

  def test_should_update_district_street
    put :update, :id => district_streets(:one).id, :district_street => { }
    assert_redirected_to district_street_path(assigns(:district_street))
  end

  def test_should_destroy_district_street
    assert_difference('DistrictStreet.count', -1) do
      delete :destroy, :id => district_streets(:one).id
    end

    assert_redirected_to district_streets_path
  end
end
