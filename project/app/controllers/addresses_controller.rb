class AddressesController < ApplicationController
  before_action :authenticate
  before_action :require_buyer
  before_action :set_address, only: [:update, :destroy]

  def create
    @address = Current.user.addresses.build(address_params)

    if @address.save
      render json: {
        success: true,
        message: t('messages.success.address.create'),
        redirect_url: user_path(Current.user)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.address.create'),
        errors: @address.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @address.update(address_params)
      render json: {
        success: true,
        message: t('messages.success.address.update'),
        redirect_url: user_path(Current.user)
      }
    else
      render json: {
        success: false,
        message: t('messages.error.address.update'),
        errors: @address.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @address.destroy
      render json: {
        success: true,
        message: t('messages.success.address.delete')
      }
    else
      render json: {
        success: false,
        message: t('messages.error.address.delete')
      }, status: :unprocessable_entity
    end
  end

  private
  def require_buyer
    unless Current.user.buyer?
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

  def set_address
    @address = Current.user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :phone, :postcode, :content, :is_default)
  end
end