require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.update!(password: 'password123', password_confirmation: 'password123')
    
    # puts "Before sign in"
    sign_in_as(@user)
    # puts "After sign in"
    # puts "Session: #{@session.inspect}"
    # puts "Cookie: #{cookies[:session_token]}"
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should show user" do
    get user_path(@user)
    assert_response :success
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_path, params: { 
        user: { 
          username: "newuser",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        } 
      }
    end
    assert_redirected_to user_path(User.last)
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
    }
    assert_redirected_to user_path(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
    assert_redirected_to users_path
  end
end