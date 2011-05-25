require 'test_helper'

class MapTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "auto generate name" do
    assert_equal 'Map Charlie', Map.create.name
    assert_equal 'Map Delta', Map.create.name
    assert_equal 'Map Echo', Map.create.name
  end
end
