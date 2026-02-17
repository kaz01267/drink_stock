require "test_helper"

class DrinkRecordTest < ActiveSupport::TestCase
  test "在庫を超える量は記録できず、在庫も減らない" do
    user  = users(:one)
    drink = user.drinks.create!(name: "テスト酒", stock_ml: 100)

    record = user.drink_records.new(
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
