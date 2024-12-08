class FavoritesController < ApplicationController
  before_action :authenticate
  before_action :set_product, only: [:create]
  before_action :set_favorite, only: [:destroy]

  def index
    @favorites = Current.user.favorites.includes(:product)
  end

  def create
    @favorite = Current.user.favorites.build(product: @product)
    if @favorite.save
      render json: {
        success: true,
        message: t('messages.success.favorite.create')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.favorite.create'),
        errors: @favorite.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @favorite.destroy
      render json: {
        success: true,
        message: t('messages.success.favorite.delete')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.favorite.delete'),
        errors: @favorite.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_favorite
    @favorite = Current.user.favorites.find(params[:id])
  end
end
