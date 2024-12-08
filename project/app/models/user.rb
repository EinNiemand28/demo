class User < ApplicationRecord
  has_secure_password

  # generates_token_for :email_verification, expires_in: 2.days do
  #   email
  # end

  # generates_token_for :password_reset, expires_in: 20.minutes do
  #   password_salt.last(10)
  # end

  has_many :sessions, dependent: :destroy

  enum :role, { :buyer => 0, :worker => 1, :admin => 2 }
  after_initialize :set_default_role, if: :new_record?

  def admin?
    self.role.to_sym == :admin
  end

  def worker?
    self.role.to_sym == :worker
  end

  def buyer?
    self.role.to_sym == :buyer
  end
    
  validates :username, uniqueness: true, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, uniqueness: { allow_blank: true }, length: { maximum: 100 }, format: { 
    with: URI::MailTo::EMAIL_REGEXP, 
    message: "请输入正确的邮箱地址", 
    allow_blank: true }
  validates :phone, uniqueness: { allow_blank: true }, format: { 
    with: /\A[0-9]{11}\z/, 
    message: "请输入正确的手机号码", 
    allow_blank: true }
  validate :email_or_phone_present

  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :username, with: -> { _1.strip }
  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :phone, with: -> { _1.strip }

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [150, 150]
  end

  validate :acceptable_avatar

  has_one :cart, dependent: :destroy

  # before_validation if: :email_changed?, on: :update do
  #   self.verified = false
  # end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def self.find_by_login(login)
    where("username = :login OR email = :login OR phone = :login", login: login).first
  end

  scope :search, ->(query) {
    where('username LIKE :q OR email LIKE :q OR phone LIKE :q', q: "%#{query}%")
  }

  scope :with_role, ->(role) {
    where(role: role) if role.present?
  }
  def avatar_thumbnail
    Rails.cache.fetch([self, "avatar_thumbnail"], expires_in: 1.hour) do
      if avatar.attached?
        avatar.variant(resize_to_fill: [40, 40]).processed
      else
        "default_avatar.png"
      end
    end
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.byte_size <= 5.megabytes
      errors.add(:avatar, "图片大小不能超过5MB")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "只支持 JPEG 或 PNG 格式")
    end
  end

  def set_default_role
    self.role ||= :buyer
  end

  def email_or_phone_present
    if email.blank? && phone.blank?
      errors.add(:email, "邮箱和手机号码至少填写一个")
      errors.add(:phone, "邮箱和手机号码至少填写一个")
    end
  end
end
