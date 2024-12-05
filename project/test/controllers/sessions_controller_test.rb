require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one) # 需要在 fixtures 中定义
  end

  test "should get sign in page" do
    get sign_in_url
    assert_response :success
  end

  test "should sign in with valid credentials" do
    post sign_in_url, params: {
      login: @user.email,
      password: "password123"
    }, as: :json
  
    assert_response :success
    assert_equal "登录成功! 即将跳转到首页..", JSON.parse(response.body)["message"]
  end

  test "should not sign in with invalid password" do
    post sign_in_url, params: {
      login: @user.email,
      password: "wrongpassword"
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "密码错误", JSON.parse(response.body)["message"]
  end

  test "should not sign in with invalid login" do
    post sign_in_url, params: {
      login: "nonexistent@example.com",
      password: "password123"
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "账号不存在", JSON.parse(response.body)["message"]
  end

  test "should sign out" do
    sign_in_as(@user) # 需要在 test_helper 中定义辅助方法
    delete sign_out_url
    assert_redirected_to root_url
  end
end