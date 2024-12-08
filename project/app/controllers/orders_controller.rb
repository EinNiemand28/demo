class OrdersController < ApplicationController
  before_action :authenticate
  before_action :set_order, only: [:show, :destroy]
  before_action :authorize, only: [:show, :destroy]
  before_action :ensure_can_delete, only: [:destroy]

  def index
    base_query = if Current.user.admin? || Current.user.worker?
      Order.includes(:user, :address, order_items: :product)
    else
      Current.user.orders.includes(:address, order_items: :product)
    end

    @orders = if params[:status].present?
      base_query.where(status: params[:status])
    else
      base_query
    end

    @orders = @orders.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def create
    @cart = Current.user.cart
    if @cart.cart_items.empty?
      render json: {
        success: false,
        message: t('messages.error.order.create')
      }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      @order = Current.user.orders.build(
        address_id: params[:address_id],
        total_amount: @cart.total_price,
        status: :unpaid
      )

      if @order.save
        @cart.cart_items.each do |item|
          @order.order_items.create(
            product_id: item.product_id,
            quantity: item.quantity,
            price: item.product.price
          )
        end
        @cart.cart_items.delete_all
        render json: {
          success: true,
          message: t('messages.success.order.create'),
          redirect_url: order_path(@order)
        }
      else
        render json: {
          success: false,
          message: t('messages.error.order.create'),
          errors: @order.errors.full_messages
        }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: {
      success: false,
      message: t('messages.error.order.create')
    }, status: :unprocessable_entity
  end

  def destroy
    if @order.destroy
      render json: {
        success: true,
        message: t('messages.success.order.delete'),
        redirect_url: orders_path
      }
    else
      render json: {
        success: false,
        message: t('messages.error.order.delete')
      }, status: :unprocessable_entity
    end
  end

  def update_status
    @order = Order.find(params[:id])

    if params[:status] == 'shipped' && !@order.can_ship?
      render json: {
        success: false,
        message: t('messages.error.order.shipped')
      }, status: :unprocessable_entity
      return
    end
    
    ActiveRecord::Base.transaction do
      if @order.update(status: params[:status])
        @order.update_product_stock! if params[:status] == 'shipped'
        render json: {
          success: true,
          message: t("messages.success.order.#{params[:status]}")
        }
      else
        render json: {
          success: false,
          message: t('messages.error.order.update'),
          errors: @order.errors.full_messages
        }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: {
      success: false,
      message: t('messages.error.order.update')
    }, status: :unprocessable_entity
  end

  private
  def set_order
    @order = Order.includes(:user, :address, order_items: :product).find(params[:id])
  end

  def authorize
    unless Current.user.admin? || Current.user.worker? || @order.user == Current.user
      respond_to do |format|
        format.html {
          redirect_to orders_path, alert: t('messages.error.unauthorized')
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

  def ensure_can_delete
    unless @order.can_delete?
      render json: {
        success: false,
        message: t('messages.error.order.delete')
      }, status: :unprocessable_entity
    end
  end
end
