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
          message: t('messages.success.user.login'),
          redirect_url: root_path
        }
      else
        render json: {
          success: false,
          message: t('messages.error.user.login'),
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: t('messages.error.user.login')
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
    redirect_to root_path, notice: t('messages.success.user.logout')
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
