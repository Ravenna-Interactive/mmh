require 'test_helper'

class HuntsControllerTest < ActionController::TestCase
  
  test "show hunt" do
    @hunt = hunts(:one)
    get :show, :id => @hunt.id
    assert_response :success
  end
  
  test "show hunt xhr" do
    @hunt = hunts(:one)
    get :show, :id => @hunt.id, :format => :json
    assert_response :success
    assert_equal 'application/json', response.content_type
  end
  
end
