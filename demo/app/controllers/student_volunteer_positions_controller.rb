class StudentVolunteerPositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_volunteer_position
  before_action :authorize_user!, only: [:approve]

  def create
    unless current_user.student?
      redirect_back_with_alert('只有学生可以报名志愿者岗位。') and return
    end
    unless @volunteer_position.registration_deadline >= Time.now
      redirect_back_with_alert('报名已截止。') and return
    end
    unless @volunteer_position.required_number > @volunteer_position.volunteers.count
      redirect_back_with_alert('报名人数已满。') and return
    end

    @student_volunteer_position = current_user.student_volunteer_positions.find_by(volunteer_position: @volunteer_position)
    if @student_volunteer_position&.pending?
      redirect_back_with_alert('您已提交申请，请等待审核。')
    elsif @student_volunteer_position&.approved?
      redirect_back_with_alert('您已经是志愿者。')
    else
      if @student_volunteer_position.nil?
        @student_volunteer_position = current_user.student_volunteer_positions.build(
          volunteer_position: @volunteer_position,
          status: :pending,
          registration_time: Time.now
        )
      else
        @student_volunteer_position.status = :pending
        @student_volunteer_position.registration_time = Time.now
      end
      @student_volunteer_position.save
      redirect_back_with_notice('已提交申请。')
    end
  end

  def approve
    unless @volunteer_position.required_number > @volunteer_position.volunteers.count
      redirect_back_with_alert('报名人数已满。') and return
    end

    @student_volunteer_position = @volunteer_position.student_volunteer_positions.find_by(params[:registration_id])
    if @student_volunteer_position.update(status: :approved)
      redirect_back_with_notice('审核成功。')
    else
      redirect_back_with_alert('审核失败。')
    end
  end

  def cancel
    @student_volunteer_position = current_user.student_volunteer_positions.find_by(volunteer_position: @volunteer_position)
    if @student_volunteer_position.update(status: :canceled)
      redirect_back_with_notice('取消申请成功。')
    else
      redirect_back_with_alert('取消申请失败。')
    end
  end

  private

  def redirect_back_with_notice(message)
    redirect_to event_volunteer_position_path(@event, @volunteer_position), notice: message
  end

  def redirect_back_with_alert(message)
    redirect_to event_volunteer_position_path(@event, @volunteer_position), alert: message
  end

  def set_volunteer_position
    @event = Event.find(params[:event_id])
    @volunteer_position = @event.volunteer_positions.find(params[:id])
  end

  def authorize_user!
    unless current_user.admin? || @volunteer_position.event.organizer_teacher == current_user
      redirect_to @volunteer_position, alert: '您没有权限执行此操作。'
    end
  end
end
