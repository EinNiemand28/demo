class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_must_be_available

  private
  def product_must_be_available
    if product.present? && quantity > product.stock
      errors.add(:quantity, "库存不足")
    end
  end
end
