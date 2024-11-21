class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ApplicationHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :telephone, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :telephone, :role_level, :password, :password_confirmation, :profile_picture])
  end

  def ensure_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "您没有权限访问该页面"
    end
  end

  # redirect_back_with_fallback notice: '操作成功'
  def redirect_back_with_fallback(fallback_location, **args)
    if request.referer.present? && request.referer != request.url
      redirect_back(fallback_location: fallback_location, **args)
    else
      redirect_to fallback_location, **args
    end
  end
end
