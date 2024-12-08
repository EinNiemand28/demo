class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { in: 2..50 }
  validates :price, numericality: { greater_than_or_equal_to: 0}
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category_id, presence: true

  has_one_attached :image
  validate :acceptable_image

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  def image_variant(variant)
    case variant
    when :thumb
      image.variant(resize_to_fill: [50, 50])
    when :medium
      image.variant(resize_to_fill: [250, 250])
    else
      image
    end
  end

  private
  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 5.megabyte
      errors.add(:image, '文件大小不能超过 5MB')
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, '只支持 JPEG 或 PNG 格式')
    end
  end
end
