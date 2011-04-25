require 'test_helper'

class HuntsControllerTest < ActionController::TestCase
  
  test "list hunts" do
    get :index
    assert_response :success
  end
  
  test "create hunt" do
    get :new
    assert_response :redirect
    assert_equal 1, session[:hunt_ids].size
  end
  
  test "show hunt" do
    @request.session[:hunt_ids] = [hunts(:alpha).id]
    
    @hunt = hunts(:alpha)
    get :show, :id => @hunt.id
    assert_response :success
  end
  
  test "show hunt xhr" do
    @request.session[:hunt_ids] = [hunts(:alpha).id]
    
    @hunt = hunts(:alpha)
    get :show, :id => @hunt.id, :format => :json
    assert_response :success
    assert_equal 'application/json', response.content_type
  end
  
end
