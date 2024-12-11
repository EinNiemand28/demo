class ApplicationsController < ApplicationController
  before_action :authenticate
  before_action :set_application, except: [:index, :new, :create]
  before_action :require_teacher, only: [:new, :create, :edit, :update, :reapply, :destroy]
  before_action :require_admin, only: [:approve, :reject, :destroy]

  def index
    @applications = if Current.user.admin?
      Application.all
    else
      Current.user.applications
    end

    if params[:status].present?
      @applications = @applications.where(status: params[:status])
    end

    @applications = @applications.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @application = Application.new
  end

  def show
  end

  def create
    @application = Current.user.applications.build(application_params)
    @application.applicant = Current.user
    @application.status = :pending

    if @application.save
      render json: {
        success: true,
        message: t('messages.success.application.create'),
        redirect_url: applications_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.create'),
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @application.update(application_params)
      render json: {
        success: true,
        message: t('messages.success.application.update'),
        redirect_url: application_path(@application)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.update'),
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def approve
    if @application.update(
      status: :approved,
      approved_at: Time.current,
      comment: params[:comment]
    )
      event = Event.create!(
        title: @application.title,
        organizing_teacher: @application.applicant,
        status: :draft,
        description: @application.plan,
        start_time: Time.current,
        end_time: Time.current + 1.day,
        location: "TBD",
        registration_deadline: Time.current - 1.day,
        max_participants: 1
      )
      @application.event = event
      NotificationService.notify_application_approved(@application)
      render json: {
        success: true,
        message: t('messages.success.application.approve'),
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.approve'),
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def reject
    if @application.update(
      status: :rejected,
      comment: params[:comment]
    )
      NotificationService.notify_application_rejected(@application)
      render json: {
        success: true,
        message: t('messages.success.application.reject')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.reject'),
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def reapply
    if @application.update(status: :pending)
      render json: {
        success: true,
        message: t('messages.success.application.reapply'),
        redirect_url: application_path(@application)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.reapply'),
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @application.destroy
      render json: {
        success: true,
        message: t('messages.success.application.delete'),
        redirect_url: applications_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.application.delete')
      }, status: :unprocessable_entity
    end
  end

  private
  def set_application
    @application = Application.find(params[:id])
  end

  def require_teacher
    unless Current.user.teacher?
      render json: {
        success: false,
        message: t('messages.error.unauthorized')
      }, status: :unauthorized
    end
  end

  def require_admin
    unless Current.user.admin?
      render json: {
        success: false,
        message: t('messages.error.unauthorized')
      }, status: :unauthorized
    end
  end

  def application_params
    params.require(:application).permit(:title, :plan, :comment, :status)
  end
end