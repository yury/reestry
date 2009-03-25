require 'test_helper'

class StreetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:streets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_streets
    assert_difference('Streets.count') do
      post :create, :streets => { }
    end

    assert_redirected_to streets_path(assigns(:streets))
  end

  def test_should_show_streets
    get :show, :id => streets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => streets(:one).id
    assert_response :success
  end

  def test_should_update_streets
    put :update, :id => streets(:one).id, :streets => { }
    assert_redirected_to streets_path(assigns(:streets))
  end

  def test_should_destroy_streets
    assert_difference('Streets.count', -1) do
      delete :destroy, :id => streets(:one).id
    end

    assert_redirected_to streets_path
  end
end
