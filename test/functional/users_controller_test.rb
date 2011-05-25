require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should show sign up form" do
    get :new
    assert_response :success
    assert_select 'form#new_user'
  end
  
  test "should create new user" do
    assert_difference 'User.count' do
      post :create, :user => {
        :email => 'beaucollins@gmail.com',
        :password => 'apassword',
        :password_confirmation => 'apassword'
      }
    end
    assert_redirected_to :root
    
  end
  
  test "should create new user and save maps" do
    @request.session[:map_ids] = [maps(:beta).id]
    assert_difference 'User.count' do
      post :create, :user => {
        :email => 'beaucollins@gmail.com',
        :password => 'apassword',
        :password_confirmation => 'apassword'
      }
    end
    @user = assigns(:user)
    assert @user
    assert_equal 1, @user.owned_maps.length
    
    
  end
  
end
