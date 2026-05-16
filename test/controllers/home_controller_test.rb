require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = people(:alice)
  end

  test "redirects unauthenticated visitor to login" do
    get root_path
    assert_redirected_to login_path
  end

  test "renders home page for authenticated user" do
    sign_in_as(@alice)
    get root_path
    assert_response :success
  end

  test "does not redirect to login after signing in" do
    sign_in_as(@alice)
    get root_path
    assert_response :success
  end

  private

  def sign_in_as(person)
    post login_path,
      params: { email: person.email, password: "password123" },
      as: :json
  end
end
