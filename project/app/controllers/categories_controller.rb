class CategoriesController < ApplicationController
  before_action :authenticate
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_woker, except: [:index, :show]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)

    
    if @category.save
      render json: {
        success: true,
        message: t('messages.success.category.create'),
        redirect_url: categories_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.category.create'),
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.where.not(id: @category.id)
  end

  def update
    if @category.update(category_params)
      render json: {
        success: true,
        message: t('messages.success.category.update'),
        redirect_url: categories_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.category.update'),
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: {
        success: true,
        message: t('messages.success.category.delete'),
        redirect_url: categories_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.category.delete'),
        errors: @category.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def require_admin_or_woker
    unless Current.user&.admin? || Current.user&.worker?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: t('messages.error.unauthorized')
        }
        format.json {
          render json: {
            success: false,
            message: t('messages.error.unauthorized')
          }, status: :unauthorized
        }
      end
    end
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :parent_id)
  end
end
