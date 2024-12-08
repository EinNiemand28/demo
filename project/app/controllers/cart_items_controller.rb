class CartItemsController < ApplicationController
  before_action :authenticate
  before_action :set_cart
  before_action :set_cart_item, only: [:update, :destroy]
  before_action :require_buyer

  def create
    @product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_by(product: @product)
    if @cart_item
      @cart_item.quantity += 1
    else
      @cart_item = @cart.cart_items.build(product: @product)
    end

    if @cart_item.save
      render json: {
        success: true,
        message: t('messages.success.cart_item.create'),
        redirect_url: cart_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.cart_item.create'),
        errors: @cart_item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      render json: {
        success: true,
        message: t('messages.success.cart_item.update'),
        redirect_url: cart_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.cart_item.update'),
        errors: @cart_item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @cart_item.destroy
      render json: {
        success: true,
        message: t('messages.success.cart_item.delete')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.cart_item.delete')
      }, status: :unprocessable_entity
    end
  end

  private
  def set_cart
    @cart = Current.user.cart || Current.user.create_cart
  end

  def require_buyer
    unless Current.user.buyer? && Current.user == @cart.user
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

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
