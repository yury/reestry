require 'test_helper'

class RealtiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:realties)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_realty
    assert_difference('Realty.count') do
      post :create, :realty => { }
    end

    assert_redirected_to realty_path(assigns(:realty))
  end

  def test_should_show_realty
    get :show, :id => realties(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => realties(:one).id
    assert_response :success
  end

  def test_should_update_realty
    put :update, :id => realties(:one).id, :realty => { }
    assert_redirected_to realty_path(assigns(:realty))
  end

  def test_should_destroy_realty
    assert_difference('Realty.count', -1) do
      delete :destroy, :id => realties(:one).id
    end

    assert_redirected_to realties_path
  end
end
