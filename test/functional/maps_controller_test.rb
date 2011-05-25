require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  
  test "list maps" do
    get :index
    assert_response :success
  end
  
  test "create map" do
    get :new
    assert_response :redirect
    assert_equal 1, session[:map_ids].size
  end
  
  test "show map" do
    @request.session[:map_ids] = [maps(:alpha).id]
    
    @map = maps(:alpha)
    get :show, :id => @map.id
    assert_response :success
  end
  
  test "show map xhr" do
    @request.session[:map_ids] = [maps(:alpha).id]
    
    @map = maps(:alpha)
    get :show, :id => @map.id, :format => :json
    assert_response :success
    assert_equal 'application/json', response.content_type
  end
  
end
