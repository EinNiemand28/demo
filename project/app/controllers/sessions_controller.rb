class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  before_action :set_session, only: [:destroy], if: -> { params[:id].present? }

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.find_by_login(params[:login])
      if user.authenticate(params[:password])
        @session = user.sessions.create!
        cookies.signed.permanent[:session_token] = @session.id
        render json: {
          success: true,
          message: "登录成功! 即将跳转到首页..",
          redirect_url: root_path
        }
      else
        render json: {
          success: false,
          message: "密码错误"
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: "账号不存在"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_session = Current.session
    if params[:id]
      @session = Current.user.sessions.find(params[:id])
      @session.destroy
    else
      current_session.destroy if current_session
    end
    cookies.delete(:session_token)
    Current.reset
    redirect_to root_path, notice: "Signed out successfully"
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
