require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to sign in when not authenticated" do
    get users_path
    assert_redirected_to sign_in_url
  end

  test "should not redirect when authenticated" do
    sign_in_as(users(:one))
    get root_url
    assert_response :success
  end
end