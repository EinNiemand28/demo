class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy reset_avatar]
  before_action :authorize_user!, only: %i[edit update destroy]

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
    respond_to do |format|
      if user_params[:avatar_picture].present?
        @user.avatar_picture.attach(user_params[:avatar_picture])
      end

      update_params = build_update_params
      return if update_params.nil?
      if @user.update(update_params)
        format.html { redirect_to @user, notice: '用户信息已更新。' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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

  def reset_avatar
    if @user.avatar_picture.attached?
      @user.avatar_picture.purge
      redirect_to @user, notice: '头像已重置。'
    else
      redirect_to @user, alert: '当前已是默认头像。'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :telephone, :role_level, :password, :password_confirmation, :avatar_picture)
    end

    def build_update_params
      params = {
        name: user_params[:name],
        email: user_params[:email].presence,
        telephone: user_params[:telephone].presence,
        role_level: user_params[:role_level]
      }

      if user_params[:password].present?
        if user_params[:password] == user_params[:password_confirmation]
          params[:password] = user_params[:password]
        else
          @user.errors.add(:password_confirmation, '两次输入的密码不一致。')
          respond_to do |format|
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
          return nil
        end
      end
      
      if params[:email].nil? && params[:telephone].nil?
        @user.errors.add(:base, '邮箱和手机号至少填写一项。')
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        return nil
      end

      params
    end

    def authorize_user!
      unless current_user.admin? || @user == current_user
        redirect_to users_path, alert: '您没有权限访问此页面。'
      end
    end
end
