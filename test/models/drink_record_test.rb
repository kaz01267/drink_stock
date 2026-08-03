require "test_helper"

class DrinkRecordTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @drink = @user.drinks.create!(
      name: "ラフロイグ",
      stock_ml: 700
    )
  end

  test "valid with consumed_ml and consumed_at" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: 30,
      consumed_at: Time.current
    )

    assert drink_record.valid?
  end

  test "invalid without consumed_ml" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: nil,
      consumed_at: Time.current
    )

    assert_not drink_record.valid?
  end

  test "invalid when consumed_ml is less than or equal to zero" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: 0,
      consumed_at: Time.current
    )

    assert_not drink_record.valid?
  end

  test "invalid without consumed_at" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: 30,
      consumed_at: nil
    )

    assert_not drink_record.valid?
  end

  test "belongs to user" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: 30,
      consumed_at: Time.current
    )

    assert_equal @user, drink_record.user
  end

  test "belongs to drink" do
    drink_record = @user.drink_records.new(
      drink: @drink,
      consumed_ml: 30,
      consumed_at: Time.current
    )

    assert_equal @drink, drink_record.drink
  end

  test "在庫を超える量は記録できず、在庫も減らない" do
    drink = @user.drinks.create!(
      name: "テスト酒",
      stock_ml: 100
    )

    record = @user.drink_records.new(
      drink: drink,
      consumed_ml: 200,
      consumed_at: Time.current
    )

    assert_no_difference "DrinkRecord.count" do
      assert_not record.save
    end

    assert_includes record.errors[:consumed_ml], "が在庫を超えています"
    assert_equal 100, drink.reload.stock_ml
  end
end
