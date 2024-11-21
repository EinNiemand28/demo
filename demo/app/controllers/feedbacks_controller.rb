class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_feedback, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :check_event_status

  def index
    @feedbacks = @event.feedbacks.order(created_at: :desc)
  end

  def new
    @feedback = current_user.feedbacks.build(event: @event)
  end

  def create
    unless @event.participants.include?(current_user)
      redirect_to @event, alert: "您未参加此活动，无法提交反馈。" and return
    end
    @feedback = current_user.feedbacks.build(feedback_params.merge(event: @event))
    @feedback.feedback_time = Time.current
    respond_to do |format|
      if @feedback.save
        format.html { redirect_to event_feedbacks_path(@event), notice: "反馈提交成功。" }
        format.json { render :index, status: :created, location: @feedback }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        @feedback.update(feedback_time: Time.current)
        format.html { redirect_to event_feedbacks_path(@event), notice: "反馈更新成功。" }
        format.json { render :index, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback.destroy
    redirect_to @event, notice: "反馈删除成功。"
  end
  
  private

  def check_event_status
    unless @event.status == "finished"
      redirect_to @event, alert: "活动尚未结束，无法进行操作。"
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_feedback
    @feedback = current_user.feedbacks.find(params[:id])
  end

  def authorize_user!
    unless current_user == @feedback.user || current_user.admin?
      redirect_to @event, alert: "您没有权限执行此操作。"
    end
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comment, :is_anonymous)
  end
end
