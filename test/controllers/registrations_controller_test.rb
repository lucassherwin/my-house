require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = people(:alice)
    @valid_params = {
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@example.com",
      password: "password123"
    }
  end

  # --- GET /signup ---

  test "renders signup page when unauthenticated" do
    get signup_path
    assert_response :success
  end

  test "redirects to root when already authenticated" do
    sign_in_as(@alice)
    get signup_path
    assert_redirected_to root_path
  end

  # --- POST /signup ---

  test "creates person and sets session with valid params" do
    assert_difference "Person.count", 1 do
      post signup_path, params: @valid_params, as: :json
    end

    assert_response :created
    person = Person.find_by(email: "jane@example.com")
    assert_not_nil person
    assert_equal person.id, session[:person_id]
  end

  test "returns ok status body on success" do
    post signup_path, params: @valid_params, as: :json
    assert response.parsed_body["ok"]
  end

  test "normalizes email on signup" do
    post signup_path, params: @valid_params.merge(email: "Jane@Example.COM"), as: :json
    person = Person.find_by!(email: "jane@example.com")
    assert_equal "jane@example.com", person.email
  end

  test "returns unprocessable entity for duplicate email" do
    post signup_path, params: @valid_params.merge(email: @alice.email), as: :json

    assert_response :unprocessable_entity
    assert_nil session[:person_id]
  end

  test "returns validation errors in body for duplicate email" do
    post signup_path, params: @valid_params.merge(email: @alice.email), as: :json

    errors = response.parsed_body["errors"]
    assert_kind_of Array, errors
    assert errors.any? { |e| e.match?(/email/i) }
  end

  test "returns unprocessable entity when first_name is missing" do
    post signup_path, params: @valid_params.merge(first_name: ""), as: :json
    assert_response :unprocessable_entity
  end

  test "returns unprocessable entity when last_name is missing" do
    post signup_path, params: @valid_params.merge(last_name: ""), as: :json
    assert_response :unprocessable_entity
  end

  test "does not create person when params are invalid" do
    assert_no_difference "Person.count" do
      post signup_path, params: @valid_params.merge(email: @alice.email), as: :json
    end
  end

  test "signup replaces existing session when already authenticated" do
    sign_in_as(@alice)

    post signup_path, params: @valid_params, as: :json

    assert_response :created
    new_person = Person.find_by(email: @valid_params[:email])
    assert_equal new_person.id, session[:person_id]
  end

  private

  def sign_in_as(person)
    post login_path,
      params: { email: person.email, password: "password123" },
      as: :json
  end
end
