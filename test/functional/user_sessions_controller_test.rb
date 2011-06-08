require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should get signin form" do
    get :new
    assert_response :success
    assert_select 'form#new_user_session'
  end
  
  test "should log in user" do
    user = users(:user)
    post :create, :user_session => {
      :email => user.email,
      :password => 'fr33dom'
    }
    assert_redirected_to :activity
    assert_equal assigns(:user_session).user, user
  end
  
end
