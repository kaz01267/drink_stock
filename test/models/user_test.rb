require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(
      email: "user_test@example.com",
      password: "password"
    )

    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(
      email: nil,
      password: "password"
    )

    assert_not user.valid?
  end

  test "invalid without password" do
    user = User.new(
      email: "user_test@example.com",
      password: nil
    )

    assert_not user.valid?
  end

  test "name must be 20 characters or less" do
    user = User.new(
      email: "user_test@example.com",
      password: "password",
      name: "あ" * 21
    )

    assert_not user.valid?
  end

  test "valid when name is blank" do
    user = User.new(
      email: "user_test@example.com",
      password: "password",
      name: ""
    )

    assert user.valid?
  end
end
