require "test_helper"

class PersonTest < ActiveSupport::TestCase
  setup do
    @alice = people(:alice)
    @valid_attrs = {
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@example.com",
      password: "password123"
    }
  end

  # --- Validations ---

  test "is valid with all required attributes" do
    assert Person.new(@valid_attrs).valid?
  end

  test "requires email" do
    assert_not Person.new(@valid_attrs.merge(email: "")).valid?
  end

  test "requires first_name" do
    assert_not Person.new(@valid_attrs.merge(first_name: "")).valid?
  end

  test "requires last_name" do
    assert_not Person.new(@valid_attrs.merge(last_name: "")).valid?
  end

  test "requires password on create" do
    assert_not Person.new(@valid_attrs.merge(password: "")).valid?
  end

  test "enforces email uniqueness" do
    duplicate = Person.new(@valid_attrs.merge(email: @alice.email))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "email uniqueness is case-insensitive" do
    duplicate = Person.new(@valid_attrs.merge(email: @alice.email.upcase))
    assert_not duplicate.valid?
  end

  # --- Email normalization ---

  test "normalizes email to lowercase on save" do
    person = Person.create!(@valid_attrs.merge(email: "Jane@Example.COM"))
    assert_equal "jane@example.com", person.email
  end

  test "normalizes email by stripping whitespace on save" do
    person = Person.create!(@valid_attrs.merge(email: "  jane@example.com  "))
    assert_equal "jane@example.com", person.email
  end

  test "find_by normalizes email for queries" do
    found = Person.find_by(email: "ALICE@EXAMPLE.COM")
    assert_equal @alice, found
  end

  # --- has_secure_password ---

  test "authenticates with correct password" do
    assert @alice.authenticate("password123")
  end

  test "returns false for wrong password" do
    assert_not @alice.authenticate("wrongpassword")
  end

  # --- Associations ---

  test "household is optional" do
    bob = people(:bob)
    assert_nil bob.household_id
    assert bob.valid?
  end

  test "belongs to a household when one is assigned" do
    assert_equal households(:one), @alice.household
  end
end
