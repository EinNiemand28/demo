class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  private
  def authenticate
    redirect_to sign_in_path unless Current.user
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip

    if session_token = (Rails.env.test? ? cookies[:session_token] : cookies.permanent.signed[:session_token])
      Current.session = Session.find_by_id(session_token)
      Current.user = Current.session&.user
    end
  end
end
