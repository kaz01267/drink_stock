require "test_helper"

class Admin::DrinksControllerTest < ActionDispatch::IntegrationTest
  test "redirects when not logged in" do
    get admin_drinks_url

    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "redirects when logged in user is not admin" do
    sign_in users(:one)

    get admin_drinks_url

    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should get index when logged in user is admin" do
    user = users(:one)
    user.update!(admin: true)

    sign_in user

    get admin_drinks_url

    assert_response :success
  end

  test "admin can search drinks by name" do
    user = users(:one)
    user.update!(admin: true)

    sign_in user

    drink = drinks(:one)

    get admin_drinks_url, params: { q: drink.name }

    assert_response :success
    assert_includes response.body, drink.name
  end
end
