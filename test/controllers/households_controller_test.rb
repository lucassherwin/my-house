require "test_helper"

class HouseholdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = people(:alice)   # has a household
    @bob   = people(:bob)     # no household
  end

  # --- new ---

  test "new redirects unauthenticated visitor to login" do
    get new_household_path
    assert_redirected_to login_path
  end

  test "new renders form when person has no household" do
    sign_in_as(@bob)
    get new_household_path
    assert_response :success
  end

  test "new redirects to show when person already has a household" do
    sign_in_as(@alice)
    get new_household_path
    assert_redirected_to household_path(@alice.household)
  end

  # --- create ---

  test "create redirects unauthenticated visitor to login" do
    post households_path, params: { household: { name: "Test" } }, as: :json
    assert_redirected_to login_path
  end

  test "create creates household and assigns it to current person" do
    sign_in_as(@bob)
    assert_difference "Household.count", 1 do
      post households_path, params: { household: { name: "Bob's Place" } }, as: :json
    end
    assert_response :created

    @bob.reload
    assert_equal "Bob's Place", @bob.household.name
  end

  test "create returns household id and name on success" do
    sign_in_as(@bob)
    post households_path, params: { household: { name: "Bob's Place" } }, as: :json
    body = response.parsed_body
    assert body["id"].present?
    assert_equal "Bob's Place", body["name"]
  end

  test "create returns errors when name is blank" do
    sign_in_as(@bob)
    assert_no_difference "Household.count" do
      post households_path, params: { household: { name: "" } }, as: :json
    end
    assert_response :unprocessable_entity
    assert_includes response.parsed_body["errors"], "Name can't be blank"
  end

  test "create blocks person who already has a household" do
    sign_in_as(@alice)
    original_household = @alice.household
    assert_no_difference "Household.count" do
      post households_path, params: { household: { name: "Second Home" } }, as: :json
    end
    assert_response :unprocessable_entity
    assert_includes response.parsed_body["errors"], "You already belong to a household"
    @alice.reload
    assert_equal original_household, @alice.household
  end

  # --- show ---

  test "show redirects unauthenticated visitor to login" do
    get household_path(households(:one))
    assert_redirected_to login_path
  end

  test "show renders household page for authenticated user" do
    sign_in_as(@alice)
    get household_path(@alice.household)
    assert_response :success
  end

  test "show redirects when person tries to access another person's household" do
    sign_in_as(@bob)
    get household_path(@alice.household)
    assert_redirected_to new_household_path
  end

  private

  def sign_in_as(person)
    post login_path,
      params: { email: person.email, password: person == @alice ? "password123" : "secret456" },
      as: :json
  end
end
