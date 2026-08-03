require "test_helper"

class DrinkTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "drink_test@example.com",
      password: "password"
    )
  end

  test "valid with name and stock_ml" do
    drink = Drink.new(
      user: @user,
      name: "ラフロイグ",
      stock_ml: 700
    )

    assert drink.valid?
  end

  test "invalid without name" do
    drink = Drink.new(
      user: @user,
      name: nil,
      stock_ml: 700
    )

    assert_not drink.valid?
  end

  test "invalid when stock_ml is negative" do
    drink = Drink.new(
      user: @user,
      name: "ラフロイグ",
      stock_ml: -1
    )

    assert_not drink.valid?
  end

  test "name is unique per user" do
    Drink.create!(
      user: @user,
      name: "ラフロイグ",
      stock_ml: 700
    )

    drink = Drink.new(
      user: @user,
      name: "ラフロイグ",
      stock_ml: 500
    )

    assert_not drink.valid?
  end

  test "same name is valid for different users" do
    other_user = User.create!(
      email: "other_drink_test@example.com",
      password: "password"
    )

    Drink.create!(
      user: @user,
      name: "ラフロイグ",
      stock_ml: 700
    )

    drink = Drink.new(
      user: other_user,
      name: "ラフロイグ",
      stock_ml: 500
    )

    assert drink.valid?
  end

  test "strips spaces from name before validation" do
    drink = Drink.new(
      user: @user,
      name: "  ラフロイグ  ",
      stock_ml: 700
    )

    drink.valid?

    assert_equal "ラフロイグ", drink.name
  end
end
