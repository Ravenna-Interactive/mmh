require 'test_helper'

class HuntsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "create a new hunt with api key" do
    @user = users(:user)
    @map = maps(:alpha)

    user = users(:user)
    @request.env[UserSession.api_key_name] = user.single_access_token
    
    
    assert_difference '@user.hunts.count' do
      post :create, :hunt => { :started_at => 1308946914 }, :map_id => @map, :format => :json
    end
        
  end
end
