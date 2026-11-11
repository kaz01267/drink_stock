
require "test_helper"

class DrinkLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get drink_logs_url
    assert_response :success
  end

  test "should create drink log" do
    assert_difference("DrinkLog.count", 1) do
      post drink_logs_url, params: {
        drink_log: {
          drink_name: "山崎",
          memo: "香りが良くて美味しかった",
          rating: 5,
          logged_at: Time.current
        }
      }
    end

    assert_redirected_to drink_logs_path

    drink_log = DrinkLog.order(:id).last
    assert_equal "山崎", drink_log.drink_name
    assert_equal users(:one), drink_log.user
  end

  test "should update drink log" do
    drink_log = DrinkLog.create!(
      user: users(:one),
      drink_name: "山崎",
      memo: "最初の感想",
      rating: 3,
      logged_at: Time.current
    )

    patch drink_log_url(drink_log), params: {
      drink_log: {
        memo: "香りが良くて美味しかった",
        rating: 5
      }
    }

    assert_redirected_to drink_logs_path

    drink_log.reload
    assert_equal "香りが良くて美味しかった", drink_log.memo
    assert_equal 5, drink_log.rating
  end

  test "should destroy drink log" do
    drink_log = DrinkLog.create!(
      user: users(:one),
      drink_name: "山崎",
      memo: "美味しかった",
      rating: 5,
      logged_at: Time.current
    )

    assert_difference("DrinkLog.count", -1) do
      delete drink_log_url(drink_log)
    end

    assert_redirected_to drink_logs_path
    assert_not DrinkLog.exists?(drink_log.id)
  end

  test "should not update another user's drink log" do
    other_user = users(:two)

    drink_log = DrinkLog.create!(
      user: other_user,
      drink_name: "白州",
      memo: "元の感想",
      rating: 4,
      logged_at: Time.current
    )

    patch drink_log_url(drink_log), params: {
      drink_log: { memo: "不正に変更された感想" }
    }

    assert_response :not_found
    assert_equal "元の感想", drink_log.reload.memo
  end

  test "should not destroy another user's drink log" do
    other_user = users(:two)

    drink_log = DrinkLog.create!(
      user: other_user,
      drink_name: "白州",
      memo: "美味しかった",
      rating: 4,
      logged_at: Time.current
    )

    assert_no_difference("DrinkLog.count") do
      delete drink_log_url(drink_log)
    end

    assert_response :not_found
    assert DrinkLog.exists?(drink_log.id)
  end

  test "should not create drink log with blank name" do
    assert_no_difference("DrinkLog.count") do
      post drink_logs_url, params: {
        drink_log: {
          drink_name: "",
          memo: "美味しかった",
          rating: 5,
          logged_at: Time.current
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get new" do
    get new_drink_log_url
    assert_response :success
  end

  test "should get edit" do
    drink_log = DrinkLog.create!(
      user: users(:one),
      drink_name: "山崎",
      memo: "美味しかった",
      rating: 5,
      logged_at: Time.current
    )

    get edit_drink_log_url(drink_log)
    assert_response :success
  end

  test "should not update drink log with invalid rating" do
    drink_log = DrinkLog.create!(
      user: users(:one),
      drink_name: "山崎",
      memo: "美味しかった",
      rating: 4,
      logged_at: Time.current
    )

    patch drink_log_url(drink_log), params: {
      drink_log: {
        rating: 6
      }
    }

    assert_response :unprocessable_entity
    assert_equal 4, drink_log.reload.rating
  end

  test "should redirect guest to login page" do
    sign_out users(:one)

    get drink_logs_url

    assert_redirected_to new_user_session_path
  end
end
