class NotificationsController < ApplicationController
  before_action :authenticate
  before_action :set_notification, except: [:index, :new, :create]
  before_action :authorize, only: [:toggle_read]
  before_action :require_admin, only: [:new, :create]

  def index
    @notifications = Current.user.notification_users
                            .includes(:notification)
                            .order(created_at: :desc)
                            .page(params[:page]).per(10)
  end
  
  def toggle_read
    @notification_user = Current.user.notification_users.find_by(notification: @notification)
    if @notification_user&.update(is_read: !@notification_user.is_read)
      render json: {
        success: true,
        message: @notification_user.is_read ? "已标记为已读" : "已标记为未读"
      }
    else
      render json: {
        success: false,
        message: "操作失败",
      }, status: :unprocessable_entity
    end
  end

  def new
    @notification = Notification.new
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def create
    @notification = Notification.new(notification_params)
    user_ids = params[:user_ids] || []

    if user_ids.empty?
      @notification.errors.add(:base, "请选择至少一个接收用户")
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).page(params[:page])
      render :new, status: :unprocessable_entity
      return
    end

    if @notification.save
      user_ids.each do |user_id|
        NotificationUser.create(user_id: user_id, notification: @notification)
      end
      render json: {
        success: true,
        message: "通知已发送",
        redirect_url: notifications_path
      }
    else
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).page(params[:page])
      render json: {
        success: false,
        message: "操作失败",
        errors: @notification.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  def authorize
    unless Current.user.notification_users.exists?(notification: @notification)
      render json: {
        success: false,
        message: t("errors.messages.unauthorized"),
      }, status: :unauthorized
    end
  end

  def require_admin
    unless Current.user.admin?
      render json: {
        success: false,
        message: t("errors.messages.unauthorized"),
      }, status: :unauthorized
    end
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:content)
  end
end