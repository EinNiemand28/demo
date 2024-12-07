class UsersController < ApplicationController
  before_action :authenticate
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_role]
  before_action :authorize, only: [:edit, :update, :destroy]

  def index
    @users = User.all

    if params[:role].present?
      @users = @users.where(role: params[:role])
    end

    if params[:query].present?
      query = params[:query].strip
      @users = @users.where('username LIKE :query OR email LIKE :query OR phone LIKE :query', 
                           query: "%#{query}%")
    end

    @users = @users.order(created_at: :asc).page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      render json: {
        success: true,
        message: t('messages.success.user.update'),
        redirect_url: user_path(@user)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.user.update'),
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: {
      success: true,
      message: t('messages.success.user.delete'),
      redirect_url: users_path
    }
  end

  def update_role
    if Current.user.admin? && !@user.admin?
      if @user.update(role: params[:role])
        render json: {
          success: true,
          message: t('messages.success.user.role_update'),
          redirect_url: users_path
        }
      else
        render json: {
          success: false,
          message: t('messages.error.user.role_update'),
          errors: @user.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
      success: false,
      message: t('messages.error.unauthorized'),
    }, status: :unauthorized
    end
  end

  private
  def authorize
    unless Current.user == @user || Current.user.admin?
      respond_to do |format|
        format.json {
          render json: {
            success: false,
            message: t('messages.error.unauthorized')
          }, status: :unauthorized
        }
        format.html {
          redirect_to root_path, notice: t('messages.error.unauthorized')
        }
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone, :avatar, :role)
  end
end