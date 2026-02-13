require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get account" do
    get account_url
    assert_response :redirect
  end
end
