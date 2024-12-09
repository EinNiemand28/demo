class EventsController < ApplicationController
  before_action :authenticate
  before_action :set_event, except: [:index, :new, :create]
  before_action :authorize, only: [:edit, :update, :destroy]

  def index
    @events = Event.all
    
    if params[:status].present?
      @events = @events.where(status: params[:status])
    end

    @events = @events.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @event = Event.new
  end

  def show
  end

  def edit
  end

  def create
    @event = Current.user.organized_events.build(event_params)
    @event.status = :pending

    if @event.save
      render json: {
        success: true,
        message: t('messages.success.event.create'),
        redirect_url: events_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.event.create'),
        errors: @event.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: {
        success: true,
        message: t('messages.success.event.update'),
        redirect_url: event_path(@event)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.event.update'),
        errors: @event.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      render json: {
        success: true,
        message: t('messages.success.event.delete'),
        redirect_url: events_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.event.delete')
      }, status: :unprocessable_entity
    end
  end

  def update_status
    if @event.update(status: params[:status])
      if params[:status] == 'upcoming'
        # NotificationService.notify_event_approved(@event)
      end
      render json: {
        success: true,
        message: t("messages.success.event.#{params[:status]}")
      }
    else
      render json: {
        success: false,
        message: t('messages.error.event.update_status'),
        errors: @event.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def authorize
      unless Current.user.admin? || @event.organizer_teacher == Current.user
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

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :status, :registration_deadline, :max_participants)
    end

    def ensure_can_delete
      unless @event.can_delete?
        render json: {
          success: false,
          message: t('messages.error.event.delete'),
        }, status: :unprocessable_entity
      end
    end
end
