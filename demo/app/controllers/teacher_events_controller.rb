class TeacherEventsController < ApplicationController
  before_action :authenticate
  before_action :set_event
  before_action :authorize
  before_action :check_time

  def create
    teacher = User.find_by(id: params[:user_id], role: :teacher)

    if teacher.nil?
      render json: {
        success: false,
        message: '教师不存在或不是教师角色'
      }, status: :unprocessable_entity and return
    end

    if @event.teachers.include?(teacher)
      render json: {
        success: false,
        message: '该教师已关联到此活动'
      }, status: :unprocessable_entity and return
    end

    if @event.teachers << teacher
      render json: {
        success: true,
        message: t('messages.success.teacher_event.create')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.teacher_event.create')
      }, status: :unprocessable_entity
    end
  end

  def destroy
    teacher_event = @event.teacher_events.find_by(id: params[:id])
    
    if teacher_event&.destroy
      render json: {
        success: true,
        message: t('messages.success.teacher_event.delete')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.teacher_event.delete')
      }, status: :unprocessable_entity
    end
  end

  private

  def check_time
    unless @event.start_time >= Time.current && Current.user.admin?
      render json: {
        success: false,
        message: '活动已开始，无法关联教师。'
      }, status: :unprocessable_entity and return
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
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
