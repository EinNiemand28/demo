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
    cookies[:session_token] = @session.id if @session
  end
end

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end