require 'test_helper'

class DistrictsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:districts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_districts
    assert_difference('Districts.count') do
      post :create, :districts => { }
    end

    assert_redirected_to districts_path(assigns(:districts))
  end

  def test_should_show_districts
    get :show, :id => districts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => districts(:one).id
    assert_response :success
  end

  def test_should_update_districts
    put :update, :id => districts(:one).id, :districts => { }
    assert_redirected_to districts_path(assigns(:districts))
  end

  def test_should_destroy_districts
    assert_difference('Districts.count', -1) do
      delete :destroy, :id => districts(:one).id
    end

    assert_redirected_to districts_path
  end
end
