require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "hunt ownership" do
    @user = users(:user)
    assert_equal 1, @user.hunts.count
    
  end
end
