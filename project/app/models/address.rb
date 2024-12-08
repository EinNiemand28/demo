class Address < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :phone, presence: true, format: { with: /\A1[3-9]\d{9}\z/ }
  validates :postcode, presence: true, format: { with: /\A\d{6}\z/ }
  validates :content, presence: true

  after_save :ensure_only_one_default, if: :is_default?

  private
  def ensure_only_one_default
    user.addresses.where.not(id: id).update_all(is_default: false)
  end
end
