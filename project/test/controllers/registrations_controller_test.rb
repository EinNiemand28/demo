require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get sign up page" do
    get sign_up_url
    assert_response :success
  end

  test "should create user with valid data" do
    assert_difference('User.count') do
      post sign_up_url, params: {
        user: {
          username: "newuser",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json
    end

    assert_response :success
    assert_equal "注册成功! 即将跳转到首页..", JSON.parse(response.body)["message"]
  end

  test "should not create user with invalid data" do
    assert_no_difference('User.count') do
      post sign_up_url, params: {
        user: {
          username: "",
          email: "invalid",
          password: "short",
          password_confirmation: "different"
        }
      }, as: :json
    end

    assert_response :unprocessable_entity
  end
end
