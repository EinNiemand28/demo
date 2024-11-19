class TeacherEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_user!

  def create
    teacher = User.find_by(id: params[:user_id], role_level: :teacher)
    if teacher.nil?
      redirect_to @event, alert: '教师不存在或不是教师角色。' and return
    end
    if @event.teachers.include?(teacher)
      redirect_to @event, alert: '该教师已关联到此活动。' and return
    end
    @event.teachers << teacher
    redirect_to @event, notice: '教师成功关联到活动。'
  end

  def destroy
    teacher_event = @event.teacher_events.find_by(id: params[:id])
    teacher = teacher_event&.user
    if teacher.nil?
      redirect_to @event, alert: '找不到教师关联。' and return
    else
      @event.teachers.delete(teacher)
      redirect_to @event, notice: '教师关联已移除。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_user!
    unless current_user.admin? || @event.organizer_teacher == current_user
      redirect_to @event, alert: '您没有权限执行此操作。'
    end
  end
end
