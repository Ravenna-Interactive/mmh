require 'test_helper'

class HuntTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "auto generate name" do
    assert_equal 'Hunt Charlie', Hunt.create.name
    assert_equal 'Hunt Delta', Hunt.create.name
    assert_equal 'Hunt Echo', Hunt.create.name
  end
end
