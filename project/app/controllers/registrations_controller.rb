class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.verified = true # Skip email verification for now

    if @user.save
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = @session.id
      render json: {
        success: true,
        message: t('messages.success.user.signup'),
        redirect_url: root_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.user.signup'),
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password, :password_confirmation)
    end
end
