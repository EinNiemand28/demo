class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy approve cancel]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[edit update destroy approve cancel]

  # GET /events or /events.json
  def index
    @events = Event.where(status: [:ongoing, :finished, :canceled])
    @upcoming_events = Event.where(status: :pending).order(start_time: :asc)
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = current_user.organized_events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = current_user.organized_events.build(event_params)
    @event.status = :pending

    if @event.save
      redirect_to @event, notice: "活动已申请，等待审核。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    if @event.update(event_params)
      redirect_to @event, notice: '活动信息已更新。'
    else
      render :edit
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    redirect_to events_url, notice: '活动已删除。'
  end

  def approve
    if current_user.admin?
      @event.update(status: :ongoing)
      redirect_to @event, notice: '活动已通过审核。'
    else
      redirect_to @event, alert: '您没有权限执行此操作。'
    end
  end

  def cancel
    if current_user.admin? || @event.organizer_teacher == current_user
      @event.update(status: :canceled)
      redirect_to @event, notice: '活动已取消。'
    else
      redirect_to @event, alert: '您没有权限执行此操作。'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def authorize_user!
      unless current_user.admin? || @event.organizer_teacher == current_user
        redirect_to events_path, alert: '您没有权限访问此页面。'
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :status, :registration_deadline, :max_participants)
    end
end
