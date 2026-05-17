require "test_helper"

class HouseholdFlowTest < ActionDispatch::IntegrationTest
  setup do
    @bob = people(:bob)  # no household
  end

  test "user without household is sent to new form via My Household link" do
    sign_in_as(@bob)
    get new_household_path
    assert_response :success
  end

  test "user creates household and is redirected to show page" do
    sign_in_as(@bob)

    post households_path, params: { household: { name: "Casa Bob" } }, as: :json
    assert_response :created

    household_id = response.parsed_body["id"]
    @bob.reload
    assert_equal household_id, @bob.household.id

    get household_path(@bob.household)
    assert_response :success
  end

  test "user with existing household is redirected away from new" do
    alice = people(:alice)
    sign_in_as(alice, password: "password123")

    get new_household_path
    assert_redirected_to household_path(alice.household)
  end

  private

  def sign_in_as(person, password: "secret456")
    post login_path, params: { email: person.email, password: password }, as: :json
  end
end
