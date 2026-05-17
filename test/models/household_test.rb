require "test_helper"

class HouseholdTest < ActiveSupport::TestCase
  test "valid with a name" do
    assert Household.new(name: "The Smiths").valid?
  end

  test "invalid without a name" do
    assert_not Household.new(name: "").valid?
    assert_not Household.new(name: nil).valid?
  end
end
