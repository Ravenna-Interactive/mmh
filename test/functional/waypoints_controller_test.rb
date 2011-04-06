require 'test_helper'

class WaypointsControllerTest < ActionController::TestCase
  
  test "create waypoint" do
    @hunt = hunts(:one)
    assert_difference 'Waypoint.count' do
      post :create, :hunt_id => @hunt.id, :waypoint => { :lat => '1.1', :lng => '1.1' }
      assert_redirected_to assigns(:waypoint)
    end
    
  end
  
  test "create waypoint xhr" do
    @hunt = hunts(:one)
    assert_difference 'Waypoint.count' do
      post :create, :hunt_id => @hunt.id, :waypoint => { :lat => '1.1', :lng => '1.1' }, :format => :json
    end
    assert_response :created
    assert_equal 'application/json', response.content_type
  end
  
  test "update waypoint" do
    @waypoint = waypoints(:alpha)
    put :update, :id => @waypoint.id, :waypoint => { :lat => '50.2', :lng => '0' }
    assert_response :redirect
    assert_equal 50.2, assigns(:waypoint).lat
    assert_equal 0, assigns(:waypoint).lng
  end
  
end
