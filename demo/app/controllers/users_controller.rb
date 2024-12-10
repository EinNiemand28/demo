class UsersController < ApplicationController
  before_action :authenticate
  before_action :set_user, except: [:index]
  before_action :require_admin, only: [:index, :destroy, :toggle_role]
  before_action :authorize, only: [:show, :edit, :update]

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

  def participated_events
    @user = User.find(params[:id])
    @events = @user.participated_events.page(params[:page]).per(12)
  end

  def volunteer_positions
    @user = User.find(params[:id])
    @applications = @user.student_volunteer_positions.includes(:volunteer_position).page(params[:page]).per(12)
  end
  
  def organized_events
    @user = User.find(params[:id])
    @events = @user.organized_events.page(params[:page]).per(12)
  end
  
  def associated_events
    @user = User.find(params[:id])
    @events = @user.associated_events.page(params[:page]).per(12)
  end

  def show
  end

  def edit
  end

  def update
    # if @user.admin?
    #   render json: {
    #     success: false,
    #     message: t('messages.error.unauthorized'),
    #   }, status: :unauthorized
    # elsif @user.update(user_params)
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
    if Current.user == @user
      render json: {
        success: false,
        message: t('messages.error.user.delete')
      }, status: :unprocessable_entity
    else
      @user.destroy
      render json: {
        success: true,
        message: t('messages.success.user.delete'),
        redirect_url: users_path
      }
    end
  end


  # TODO
  def reset_avatar
    if @user.avatar_picture.attached?
      @user.avatar_picture.purge
      redirect_to @user, notice: '头像已重置。'
    else
      redirect_to @user, alert: '当前已是默认头像。'
    end
  end

  def toggle_role
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
  def require_admin
    unless Current.user&.admin?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: t('messages.error.unauthorized')
        }
        format.json {
          render json: {
            success: false,
            message: t('messages.error.unauthorized')
          }, status: :unauthorized
        }
      end
    end
  end

  def authorize
    unless (Current.user == @user || Current.user.admin?)
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
