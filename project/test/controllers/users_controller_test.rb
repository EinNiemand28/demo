require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.update!(password: 'password123', password_confirmation: 'password123')
    
    # puts "Before sign in"
    sign_in_as(@user)
    assert Current.user, "用户未正确登录"
    # puts "After sign in"
    # puts "Session: #{@session.inspect}"
    # puts "Cookie: #{cookies[:session_token]}"
  end

  def teardown
    Current.reset
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should show user" do
    get user_path(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_path(@user), params: { 
      user: { 
        username: "updated_name",
        email: "updated@example.com" 
      } 
    }, as: :json
  
    assert_response :success
    json = JSON.parse(response.body)
    assert json['success']
    assert_equal "个人资料已更新", json['message']
    assert_equal user_path(@user), json['redirect_url']
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
    
    assert_response :success
    json = JSON.parse(response.body)
    assert json['success']
    assert_equal "删除成功", json['message']
    assert_equal users_path, json['redirect_url']
  end
end