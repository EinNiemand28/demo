class StudentEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :destroy]
  before_action :set_student_event, only: [:destroy]

  def create
    unless current_user.student?
      redirect_to @event, alert: '只有学生可以报名活动。' and return
    end
    unless @event.registration_deadline >= Time.now
      redirect_to @event, alert: '报名已截止。' and return
    end
    unless @event.max_participants > @event.participants.count
      redirect_to @event, alert: '报名人数已满。' and return
    end

    @student_event = current_user.student_events.find_by(event: @event)
    if @student_event&.registered?
      redirect_to @event, alert: '您已报名该活动。' and return
    else
      if @student_event.nil?
        @student_event = current_user.student_events.build(event: @event)
      else
        @student_event.status = :registered
      end
      @student_event.registration_time = Time.now
      @student_event.save
      redirect_to @event, notice: '报名成功。'
    end
  end

  def destroy
    if @student_event&.update(status: :canceled)
      redirect_to @event, notice: '取消报名成功。'
    else
      redirect_to @event, alert: '取消报名失败。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_student_event
    @student_event = current_user.student_events.find_by(event: @event)
    unless @student_event
      redirect_to @event, alert: '找不到报名记录。'
    end
  end
end
