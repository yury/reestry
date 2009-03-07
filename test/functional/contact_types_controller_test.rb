require 'test_helper'

class ContactTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_contact_type
    assert_difference('ContactType.count') do
      post :create, :contact_type => { }
    end

    assert_redirected_to contact_type_path(assigns(:contact_type))
  end

  def test_should_show_contact_type
    get :show, :id => contact_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => contact_types(:one).id
    assert_response :success
  end

  def test_should_update_contact_type
    put :update, :id => contact_types(:one).id, :contact_type => { }
    assert_redirected_to contact_type_path(assigns(:contact_type))
  end

  def test_should_destroy_contact_type
    assert_difference('ContactType.count', -1) do
      delete :destroy, :id => contact_types(:one).id
    end

    assert_redirected_to contact_types_path
  end
end
