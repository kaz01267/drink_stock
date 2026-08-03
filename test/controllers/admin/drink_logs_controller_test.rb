require "test_helper"

class Admin::DrinkLogsControllerTest < ActionDispatch::IntegrationTest
  test "redirects when not logged in" do
    get admin_drink_logs_url

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "redirects when logged in user is not admin" do
    sign_in users(:one)

    get admin_drink_logs_url

    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should get index when logged in user is admin" do
    user = users(:one)
    user.update!(admin: true)

    sign_in user

    get admin_drink_logs_url

    assert_response :success
  end
end
