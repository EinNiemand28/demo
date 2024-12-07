class PasswordsController < ApplicationController
  before_action :authenticate
  before_action :set_user

  def edit
  end

  def update
    if @user.authenticate(user_params[:password_challenge])
      if @user.update(user_params)
        render json: {
          success: true,
          message: t("messages.success.user.password_update"),
          redirect_url: user_path(@user)
        }
      else
        render json: {
          success: false,
          message: t("messages.error.user.password_update"),
          errors: @user.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: t("messages.error.user.password_wrong")
      }, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
    end
end
