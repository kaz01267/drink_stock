require "test_helper"

class DrinkRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @drink = @user.drinks.create!(name: "テスト酒", stock_ml: 500)
  end

  test "should get new" do
    get new_drink_drink_record_url(@drink)
    assert_response :success
  end

  test "should create drink_record and decrease stock" do
    assert_difference("DrinkRecord.count", 1) do
      post drink_drink_records_url(@drink), params: {
        drink_record: { consumed_ml: 100, consumed_at: Time.current }
      }
    end

    assert_response :redirect
    assert_equal 400, @drink.reload.stock_ml
  end

  test "should update drink_record and recalculate stock" do
    drink_record = @user.drink_records.create!(
      drink: @drink,
      consumed_ml: 100,
      consumed_at: Time.current
    )

    @drink.update!(stock_ml: 400)

    patch drink_drink_record_url(@drink, drink_record), params: {
      drink_record: {
        consumed_ml: 200,
        consumed_at: drink_record.consumed_at
      }
    }

    assert_response :redirect
    assert_equal 200, drink_record.reload.consumed_ml
    assert_equal 300, @drink.reload.stock_ml
  end

  test "should destroy drink_record and restore stock" do
    drink_record = @user.drink_records.create!(
      drink: @drink,
      consumed_ml: 100,
      consumed_at: Time.current
    )

    @drink.update!(stock_ml: 400)

    assert_difference("DrinkRecord.count", -1) do
      delete drink_drink_record_url(@drink, drink_record)
    end

    assert_response :redirect
    assert_equal 500, @drink.reload.stock_ml
  end
end
