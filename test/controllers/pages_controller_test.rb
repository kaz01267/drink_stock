require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get guide" do
    get guide_url
    assert_response :success
  end

  test "should redirect account when not logged in" do
    get account_url
    assert_response :redirect
  end

  test "should get account when logged in" do
    sign_in users(:one)

    get account_url
    assert_response :success
  end
end
