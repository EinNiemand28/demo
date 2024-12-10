class StudentVolunteerPositionsController < ApplicationController
  before_action :authenticate
  before_action :set_volunteer_position
  before_action :authorize, only: [:approve]

  def create
    unless Current.user.student?
      render json: {
        success: false,
        message: "只有学生可以申请志愿者岗位。"
      }, status: :unauthorized and return
    end
    unless @volunteer_position.registration_deadline >= Time.current
      render json: {
        success: false,
        message: "报名已截止。"
      }, status: :forbidden and return
    end
    unless @volunteer_position.required_number > @volunteer_position.volunteers.count
      render json: {
        success: false,
        message: "人数已满。"
      }, status: :forbidden and return
    end

    @student_volunteer_position = Current.user.student_volunteer_positions.find_by(volunteer_position: @volunteer_position)
    if @student_volunteer_position&.pending?
      render json: {
        success: false,
        message: "您已经提交过申请。"
      }, status: :forbidden and return
    elsif @student_volunteer_position&.approved?
      render json: {
        success: false,
        message: "您已经通过审核。"
      }, status: :forbidden and return
    else
      if @student_volunteer_position.nil?
        @student_volunteer_position = Current.user.student_volunteer_positions.build(
          volunteer_position: @volunteer_position,
          status: :pending,
        )
      else
        @student_volunteer_position.status = :pending
      end
      if @student_volunteer_position.save
        render json: {
          success: true,
          message: t('messages.success.student_volunteer_position.create')
        }
      else
        render json: {
          success: false,
          message: t('messages.error.student_volunteer_position.create'),
          errors: @student_volunteer_position.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  end

  def approve
    unless @volunteer_position.required_number > @volunteer_position.volunteers.count
      render json: {
        success: false,
        message: "人数已满。"
      }, status: :forbidden and return
    end

    @student_volunteer_position = @volunteer_position.student_volunteer_positions.find_by(params[:registration_id])
    if @student_volunteer_position.update(status: :approved)
      NotificationService.notify_volunteer_approved(@student_volunteer_position)
      render json: {
        success: true,
        message: t('messages.success.student_volunteer_position.approve')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.student_volunteer_position.approve'),
        errors: @student_volunteer_position.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def cancel
    @student_volunteer_position = Current.user.student_volunteer_positions.find_by(volunteer_position: @volunteer_position)
    if @student_volunteer_position.update(status: :canceled)
      render json: {
        success: true,
        message: t('messages.success.student_volunteer_position.cancel')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.student_volunteer_position.cancel'),
        errors: @student_volunteer_position.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def set_volunteer_position
    @event = Event.find(params[:event_id])
    @volunteer_position = @event.volunteer_positions.find(params[:id])
  end

  def authorize
    unless Current.user.admin? || @volunteer_position.event.organizing_teacher == Current.user
      render json: {
        success: false,
        message: t('messages.error.unauthorized')
      }, status: :unauthorized and return
    end
  end
end
