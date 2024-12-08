class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items, source: :product, dependent: :destroy

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  enum :status, { :unpaid => 0, :paid => 1, :shipped => 2, :completed => 3, :canceled => 4 }

  after_initialize :set_default_status, if: :new_record?
  validate :valid_status_transition, if: :status_changed?

  def valid_status_transition
    case status_was.to_sym
    when :unpaid
      unless [:paid, :canceled].include?(status.to_sym)
        errors.add(:status, "未支付订单只能转为已支付或已取消")
      end
    when :paid
      unless [:shipped, :canceled].include?(status.to_sym)
        errors.add(:status, "已支付订单只能转为已发货或已取消")
      end
    when :shipped
      unless status.to_sym == :completed
        errors.add(:status, "已发货订单只能转为已完成")
      end
    when :completed, :canceled
      errors.add(:status, "订单已完成或已取消")
    end
  end

  def completed?
    status.to_sym == :completed
  end

  def canceled?
    status.to_sym == :canceled
  end

  def unpaid?
    status.to_sym == :unpaid
  end

  def can_delete?
    completed? || canceled? || unpaid?
  end

  def can_ship?
    order_items.all? { |item| item.quantity <= item.product.stock }
  end

  def update_product_stock!
    order_items.each do |item|
      item.product.decrement!(:stock, item.quantity)
    end
  end

  private
  def set_default_status
    self.status ||= :unpaid
  end
end
