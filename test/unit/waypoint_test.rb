require 'test_helper'

class WaypointTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "requires hunt" do
    waypoint = Waypoint.new
    assert !waypoint.valid?
    assert_equal 1, waypoint.errors[:hunt_id].length
  end
  
  test "sets position as last in hunt" do
    waypoint = Waypoint.new(:hunt => hunts(:alpha), :lat => 1, :lng => 1)
    assert_difference 'Waypoint.count' do
      waypoint.save
      assert_equal 1, waypoint.position
    end
  end
  
  test "sets default waypoint names" do
    waypoint = Waypoint.new(:hunt => hunts(:alpha))
    assert waypoint.hunt
    waypoint.valid?
    assert_equal 'Alpha', waypoint.name
  end
  
end
