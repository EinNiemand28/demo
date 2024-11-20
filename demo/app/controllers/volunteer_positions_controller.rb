class VolunteerPositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_volunteer_position, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: %i[ new create edit update destroy ]

  # GET /volunteer_positions/1 or /volunteer_positions/1.json
  def show
  end

  # GET /volunteer_positions/1/edit
  def edit
  end
  
  # GET /volunteer_positions/new
  def new
    @volunteer_position = @event.volunteer_positions.build
  end

  # POST /volunteer_positions or /volunteer_positions.json
  def create
    @volunteer_position = @event.volunteer_positions.build(volunteer_position_params)
    respond_to do |format|
      if @volunteer_position.save
        format.html { redirect_to event_volunteer_position_path(@event, @volunteer_position), notice: '志愿者岗位创建成功。' }
        format.json { render :show, status: :created, location: @volunteer_position }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @volunteer_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_positions/1 or /volunteer_positions/1.json
  def update
    respond_to do |format|
      if @volunteer_position.update(volunteer_position_params)
        format.html { redirect_to event_volunteer_position_path(@event, @volunteer_position), notice: '志愿者岗位更新成功。' }
        format.json { render :show, status: :ok, location: @volunteer_position }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_positions/1 or /volunteer_positions/1.json
  def destroy
    @volunteer_position.destroy
    redirect_to event_path(@event), notice: '志愿者岗位删除成功。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    def set_volunteer_position
      @volunteer_position = @event.volunteer_positions.find(params[:id])
    end

    def volunteer_position_params
      params.require(:volunteer_position).permit(:name, :description, :required_number, :volunteer_hours, :registration_deadline)
    end

    def authorize_user!
      unless current_user.admin? || @event.organizer_teacher == current_user
        redirect_to @event, alert: '您没有权限执行此操作。'
      end
    end
end
