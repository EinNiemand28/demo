class FeedbacksController < ApplicationController
  before_action :authenticate
  before_action :set_event
  before_action :set_feedback, only: [:edit, :update, :destroy]
  before_action :authorize, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @feedback = Current.user.feedbacks.build(event: @event)
  end

  def create
    @feedback = Current.user.feedbacks.build(feedback_params)
    @feedback.event = @event
    if @feedback.save
      render json: {
        success: true,
        message: t('messages.success.feedback.create'),
        redirect_url: event_feedbacks_path(@event)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.feedback.create'),
        errors: @feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
    render json: @feedback.as_json(only: [:id, :rating, :comment, :is_anonymous])
  end

  def update
    if @feedback.update(feedback_params)
      render json: {
        success: true,
        message: t('messages.success.feedback.update'),
        redirect_url: event_feedbacks_path(@event)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.feedback.update'),
        errors: @feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @feedback.destroy
      render json: {
        success: true,
        message: t('messages.success.feedback.delete'),
        redirect_url: event_feedbacks_path(@event)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.feedback.delete'),
        errors: @feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_feedback
    @feedback = Current.user.feedbacks.find(params[:id])
  end

  def authorize
    unless Current.user == @feedback.user || Current.user.admin?
      render json: {
        success: false,
        message: t('messages.error.unauthorized')
      }, status: :unauthorized
    end
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comment, :is_anonymous)
  end
end
