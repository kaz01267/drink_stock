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

  test "should create drink_record" do
    assert_difference("DrinkRecord.count", 1) do
      post drink_drink_records_url(@drink), params: {
        drink_record: { consumed_ml: 100, consumed_at: Time.current }
      }
    end
    assert_response :redirect
  end
end
