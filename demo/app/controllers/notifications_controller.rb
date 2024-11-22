class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!, only: [:new, :create]

  def index
    @notifications = current_user.notifications_with_status.page(params[:page])
  end
  
  def toggle_read
    @notification_user = current_user.notification_users.find(params[:id])
    @notification_user.update(is_read: !@notification_user.is_read)

    respond_to do |format|
      format.html { redirect_back_with_fallback notice: "操作成功" }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          @notification_user, 
          partial: "notification", 
          locals: { notification_user: @notification_user }
        )
      }
    end
  end

  def new
    @notification = Notification.new
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.notification_time = Time.current
    user_ids = params[:user_ids] || []

    if user_ids.empty?
      @notification.errors.add(:base, "请选择至少一个接收用户")
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).page(params[:page])
      render :new, status: :unprocessable_entity
      return
    end

    respond_to do |format|
      if @notification.save
        user_ids.each do |user_id|
          NotificationUser.create(user_id: user_id, notification: @notification)
        end
        format.html { redirect_to notifications_path, notice: "通知发送成功" }
        format.json { render :show, status: :created, location: @notification }
      else
        @q = User.ransack(params[:q])
        @users = @q.result(distinct: true).page(params[:page])
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private

  def notification_params
    params.require(:notification).permit(:content)
  end
end