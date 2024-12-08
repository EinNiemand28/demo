class ProductsController < ApplicationController
  before_action :authenticate, except: [:index]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_woker, except: [:index, :show]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: {
        success: true,
        message: t('messages.success.product.create'),
        redirect_url: products_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.product.create'),
        errors: @product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @product.update(product_params)
      render json: {
        success: true,
        message: t('messages.success.product.update'),
        redirect_url: products_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.product.update'),
        errors: @product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {
        success: true,
        message: t('messages.success.product.delete'),
        redirect_url: products_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.product.delete')
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

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, :image)
  end
end
