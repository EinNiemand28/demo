class StudentEventsController < ApplicationController
  before_action :authenticate
  before_action :set_event
  before_action :set_student_event, only: [:destroy]
  before_action :check_time

  def create
    unless Current.user.student?
      render json: {
        success: false,
        message: '只有学生可以报名活动。'
      }, status: :forbidden and return
    end
    unless @event.max_participants > @event.participants.count
      render json: {
        success: false,
        message: '报名人数已满。'
      }, status: :forbidden and return
    end

    @student_event = Current.user.student_events.find_by(event: @event)
    if @student_event
      render json: {
        success: false,
        message: '您已报名该活动。'
      }, status: :forbidden
    else
      @student_event = Current.user.student_events.build(event: @event)
      @student_event.registration_time = Time.current
      if @student_event.save
        render json: {
          success: true,
          message: t('messages.success.student_event.create'),
        }
      else
        render json: {
          success: false,
          message: t('messages.error.student_event.create'),
        }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @student_event.destroy
      render json: {
        success: true,
        message: t('messages.success.student_event.delete'),
      }
    else
      render json: {
        success: false,
        message: t('messages.error.student_event.delete'),
      }, status: :unprocessable_entity
    end
  end

  private

  def check_time
    unless @event.registration_deadline >= Time.current && Current.user.admin?
      render json: {
        success: false,
        message: '报名已截止。'
      }, status: :forbidden and return
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_student_event
    @student_event = Current.user.student_events.find_by(event: @event)
    unless @student_event
      render json: {
        success: false,
        message: '未找到报名记录。'
      }, status: :not_found
    end
  end
end
