class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/:id
  def update
    if @user.admin?
      if @user != current_user
        redirect_to @user, alert: '不能修改其他管理员的信息。' and return
      end
    end
    user_params.each do |k, v|
      @user[k] = v unless v.blank?
    end
    if @user.save
      redirect_to @user, notice: '用户信息已更新。'
    else
      Rails.logger.debug @user.errors.full_messages
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    if @user == current_user
      redirect_to users_path, alert: '您不能删除自己的账户。' and return
    end
    @user.destroy
    redirect_to users_path, notice: '用户已被删除。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :telephone, :role_level, :password, :password_confirmation, :profile_picture)
    end
end
