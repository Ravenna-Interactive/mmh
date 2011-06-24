require 'test_helper'

class MapsControllerTest < ActionController::TestCase
    
  test "list maps" do
    UserSession.create(users(:user))
    get :index
    assert_response :success
  end
  
  test "single access token" do
    user = users(:user)
    @request.env[UserSession.api_key_name] = user.single_access_token
    get :index
    assert @controller.send(:current_user), "There should be a user"
  end
  
  test "create map" do
    get :new
    assert_response :redirect
    assert session[:unsaved_map_id], "There should be an unsaved map"
  end
  
  test "show map" do
    @request.session[:map_ids] = [maps(:alpha).id]
    
    @map = maps(:alpha)
    get :show, :id => @map.id
    assert_response :redirect
  end
  
  test "show map xhr" do
    @request.session[:unsaved_map_id] = maps(:alpha).id
    
    @map = maps(:alpha)
    get :show, :id => @map.id, :format => :json
    assert_response :success
    assert_equal 'application/json', response.content_type
  end
  
end
