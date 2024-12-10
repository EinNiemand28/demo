class VolunteerPositionsController < ApplicationController
  before_action :authenticate
  before_action :set_event
  before_action :set_volunteer_position, except: [:index, :new, :create]
  before_action :authorize, except: [:index, :show]

  def index
    @volunteer_positions = @event.volunteer_positions  
  end

  def show
  end

  def edit
  end
  
  def new
    @volunteer_position = @event.volunteer_positions.build
  end

  def create
    @volunteer_position = @event.volunteer_positions.build(volunteer_position_params)
    
    if @volunteer_position.save
      render json: {
        success: true,
        message: t('messages.success.volunteer_position.create'),
        redirect_url: event_volunteer_position_path(@event, @volunteer_position)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.volunteer_position.create'),
        errors: @volunteer_position.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @volunteer_position.update(volunteer_position_params)
      render json: {
        success: true,
        message: t('messages.success.volunteer_position.update'),
        redirect_url: event_volunteer_position_path(@event, @volunteer_position)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.volunteer_position.update'),
        errors: @volunteer_position.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @volunteer_position.destroy
      render json: {
        success: true,
        message: t('messages.success.volunteer_position.destroy'),
        redirect_url: event_path(@event)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.volunteer_position.destroy'),
        errors: @volunteer_position.errors.full_messages
      }, status: :unprocessable
    end
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_volunteer_position
    @volunteer_position = @event.volunteer_positions.find(params[:id])
  end

  def volunteer_position_params
    params.require(:volunteer_position).permit(:name, :description, :required_number, :volunteer_hours, :registration_deadline)
  end

  def authorize
    unless Current.user.admin? || @event.organizing_teacher == Current.user
      render json: {
        success: false,
        message: t('messages.error.unauthorized')
      }, status: :unauthorized and return
    end
  end
end
