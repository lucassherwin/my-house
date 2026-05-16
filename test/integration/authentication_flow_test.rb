require "test_helper"

# Tests the complete authentication lifecycle across multiple requests,
# verifying that session state carries correctly between actions.
class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @alice = people(:alice)
  end

  test "signup flow: creates account and protects home page" do
    # Before signup, root is off-limits
    get root_path
    assert_redirected_to login_path

    # Sign up
    post signup_path,
      params: { first_name: "New", last_name: "User", email: "new@example.com", password: "pass1234" },
      as: :json
    assert_response :created

    # Session is set immediately after signup
    person = Person.find_by(email: "new@example.com")
    assert_equal person.id, session[:person_id]

    # Home page is now accessible
    get root_path
    assert_response :success
  end

  test "login flow: session persists across requests" do
    post login_path,
      params: { email: @alice.email, password: "password123" },
      as: :json
    assert_response :ok

    # Session carries to the next request
    get root_path
    assert_response :success

    get root_path
    assert_response :success
  end

  test "logout flow: clears session and blocks access to home page" do
    post login_path,
      params: { email: @alice.email, password: "password123" },
      as: :json

    delete logout_path
    assert_redirected_to login_path

    # Home is blocked again after logout
    get root_path
    assert_redirected_to login_path
  end

  test "login redirect: authenticated user visiting /login goes to /" do
    post login_path,
      params: { email: @alice.email, password: "password123" },
      as: :json

    get login_path
    assert_redirected_to root_path
  end

  test "signup redirect: authenticated user visiting /signup goes to /" do
    post login_path,
      params: { email: @alice.email, password: "password123" },
      as: :json

    get signup_path
    assert_redirected_to root_path
  end

  test "failed login does not grant access to home page" do
    post login_path,
      params: { email: @alice.email, password: "wrongpassword" },
      as: :json
    assert_response :unauthorized

    get root_path
    assert_redirected_to login_path
  end

  test "deleted person loses access on next request" do
    post login_path, params: { email: @alice.email, password: "password123" }, as: :json
    @alice.destroy
    get root_path
    assert_redirected_to login_path
  end
end
