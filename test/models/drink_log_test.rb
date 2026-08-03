require "test_helper"

class DrinkLogTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "drink_log_test@example.com",
      password: "password"
    )

    @drink = Drink.create!(
      user: @user,
      name: "ラフロイグ",
      stock_ml: 700
    )
  end

  test "valid with drink, drink_name, memo, rating and logged_at" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      memo: "香りが良かった",
      rating: 4,
      logged_at: Time.current
    )

    assert drink_log.valid?
  end

  test "valid without drink when drink_name is present" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: nil,
      drink_name: "外で飲んだビール",
      memo: "美味しかった",
      rating: 3,
      logged_at: Time.current
    )

    assert drink_log.valid?
  end

  test "valid without drink_name when drink is present" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: nil,
      memo: "美味しかった",
      rating: 3,
      logged_at: Time.current
    )

    assert drink_log.valid?
  end

  test "sets logged_at when logged_at is blank" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      memo: "美味しかった",
      rating: 3,
      logged_at: nil
    )

    assert drink_log.valid?
    assert drink_log.logged_at.present?
  end

  test "valid when memo is blank" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      memo: "",
      rating: 3,
      logged_at: Time.current
    )

    assert drink_log.valid?
  end

  test "valid when rating is blank" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      memo: "美味しかった",
      rating: nil,
      logged_at: Time.current
    )

    assert drink_log.valid?
  end

  test "invalid when rating is less than 1" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      rating: 0,
      logged_at: Time.current
    )

    assert_not drink_log.valid?
  end

  test "invalid when rating is greater than 5" do
    drink_log = DrinkLog.new(
      user: @user,
      drink: @drink,
      drink_name: "ラフロイグ",
      rating: 6,
      logged_at: Time.current
    )

    assert_not drink_log.valid?
  end
end
