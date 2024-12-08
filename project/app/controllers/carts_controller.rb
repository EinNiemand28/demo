class CartsController < ApplicationController
  before_action :authenticate
  before_action :set_cart
  before_action :require_buyer

  def show
    @cart_items = @cart.cart_items.includes(:product)
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
end
