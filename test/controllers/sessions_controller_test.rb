require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = people(:alice)
  end

  # --- GET /login ---

  test "renders login page when unauthenticated" do
    get login_path
    assert_response :success
  end

  test "redirects to root when already authenticated" do
    sign_in_as(@alice)
    get login_path
    assert_redirected_to root_path
  end

  # --- POST /login ---

  test "returns ok and sets session with valid credentials" do
    post login_path,
      params: { email: @alice.email, password: "password123" },
      as: :json

    assert_response :ok
    assert_equal @alice.id, session[:person_id]
  end

  test "accepts email in any case" do
    post login_path,
      params: { email: @alice.email.upcase, password: "password123" },
      as: :json

    assert_response :ok
    assert_equal @alice.id, session[:person_id]
  end

  test "returns unauthorized for wrong password" do
    post login_path,
      params: { email: @alice.email, password: "wrongpassword" },
      as: :json

    assert_response :unauthorized
    assert_nil session[:person_id]
  end

  test "returns unauthorized for unknown email" do
    post login_path,
      params: { email: "nobody@example.com", password: "password123" },
      as: :json

    assert_response :unauthorized
    assert_nil session[:person_id]
  end

  test "returns error message in body on failure" do
    post login_path,
      params: { email: @alice.email, password: "wrongpassword" },
      as: :json

    body = response.parsed_body
    assert body["error"].present?
  end

  test "login as a second user replaces the first user's session" do
    sign_in_as(@alice)
    bob = people(:bob)

    post login_path,
      params: { email: bob.email, password: password_for(bob) },
      as: :json

    assert_response :ok
    assert_equal bob.id, session[:person_id]
  end

  # --- DELETE /logout ---

  test "clears session and redirects to login" do
    sign_in_as(@alice)
    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:person_id]
  end

  private

  def sign_in_as(person)
    post login_path,
      params: { email: person.email, password: password_for(person) },
      as: :json
  end

  # Returns the plaintext password matching the fixture's password_digest.
  def password_for(person)
    { people(:alice) => "password123", people(:bob) => "secret456" }.fetch(person)
  end
end
