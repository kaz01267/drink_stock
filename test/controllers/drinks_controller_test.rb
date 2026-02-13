require "test_helper"

class DrinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @drink = Drink.create!(user: users(:one), name: "角ハイ", stock_ml: 720)
  end

  test "should get index" do
    get drinks_url
    assert_response :success
  end

  test "should get new" do
    get new_drink_url
    assert_response :success
  end

  test "should create drink" do
    assert_difference("Drink.count", 1) do
      post drinks_url, params: { drink: { name: "赤ワイン", stock_ml: 500 } }
    end
    assert_redirected_to drinks_url
  end

  test "should get edit" do
    get edit_drink_url(@drink)
    assert_response :success
  end

  test "should update drink" do
    patch drink_url(@drink), params: { drink: { name: "角ハイ（更新）", stock_ml: 600 } }
    assert_redirected_to drinks_url
  end

  test "should destroy drink" do
    assert_difference("Drink.count", -1) do
      delete drink_url(@drink)
    end
    assert_redirected_to drinks_url
  end
end
