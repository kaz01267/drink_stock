require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    user = users(:one)
    sign_in user

    get dashboard_url
    assert_response :success
  end
end