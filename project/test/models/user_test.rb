require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(
      username: "testuser",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = "other@example.com"
    assert_not duplicate_user.valid?
  end

  test "email format should be valid" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "phone format should be valid" do
    valid_phones = %w[13800138000 15912345678 18687654321]
    valid_phones.each do |valid_phone|
      @user.email = nil
      @user.phone = valid_phone
      assert @user.valid?, "#{valid_phone.inspect} should be valid"
    end
  end

  test "should require email or phone" do
    @user.email = nil
    @user.phone = nil
    assert_not @user.valid?
  end

  test "find_by_login should work with username" do
    @user.save
    found_user = User.find_by_login(@user.username)
    assert_equal @user, found_user
  end

  test "find_by_login should work with email" do
    @user.save
    found_user = User.find_by_login(@user.email)
    assert_equal @user, found_user
  end
end
