# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module SignInHelper
  def sign_in_as(user)
    post sign_in_path, params: { 
      login: user.email, 
      password: 'password123' 
    }, as: :json
    
    @session = user.sessions.last
    if @session
      cookies[:session_token] = @session.id
      # 设置 Current 对象
      Current.session = @session
      Current.user = user
    end
  end

  def sign_out
    delete sign_out_path
    Current.reset
  end
end

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end