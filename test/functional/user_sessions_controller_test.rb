require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should get signin form" do
    get :new
    assert_response :success
    assert_select 'form#new_user_session'
  end
  
  test "should log in user" do
    post :create, :user_session => {
      :email => 'unclesam@us.gov',
      :password => 'fr33dom'
    }
    assert_redirected_to :activity
    assert @controller.send(:current_user?), 'No user session'
  end
  
end
