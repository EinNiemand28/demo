class User < ApplicationRecord
  has_secure_password

  # generates_token_for :email_verification, expires_in: 2.days do
  #   email
  # end

  # generates_token_for :password_reset, expires_in: 20.minutes do
  #   password_salt.last(10)
  # end

  has_many :sessions, dependent: :destroy

  validates :username, uniqueness: true, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, uniqueness: { allow_blank: true }, length: { maximum: 50 }, format: { 
    with: URI::MailTo::EMAIL_REGEXP, 
    message: "请输入正确的邮箱地址", 
    allow_blank: true }
  validates :phone, uniqueness: { allow_blank: true }, format: { 
    with: /\A[0-9]{11}\z/, 
    message: "请输入正确的手机号码", 
    allow_blank: true }
  validate :email_or_phone_present
  before_save :normalize_empty_strings

  validates :password, allow_nil: true, length: { minimum: 6 }

  normalizes :username, with: -> { _1.strip }
  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :phone, with: -> { _1.strip }

  enum :role, { :student => 0, :teacher => 1, :admin => 2 }
  after_initialize :set_default_role, if: :new_record?

  has_many :teacher_events, dependent: :destroy
  has_many :organized_events, class_name: "Event", foreign_key: "organizing_teacher_id", dependent: :nullify
  has_many :associated_events, through: :teacher_events, source: :event

  has_many :student_events, dependent: :destroy
  has_many :participated_events, through: :student_events, source: :event

  has_many :student_volunteer_positions, dependent: :destroy
  has_many :registered_volunteer_positions, -> { where(student_volunteer_positions: { status: :approved }) }, source: :volunteer_position, through: :student_volunteer_positions

  has_many :feedbacks, dependent: :destroy

  has_many :notification_users, dependent: :destroy
  has_many :notifications, through: :notification_users, source: :notification

  has_many :applications, foreign_key: "applicant_id", dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[username email phone role]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [150, 150]
  end

  def avatar_thumbnail
    if avatar.attached?
      begin
        Rails.cache.fetch([self, "avatar_thumbnail", avatar.blob.id], expires_in: 1.hour) do
          avatar.variant(resize_to_fill: [40, 40]).processed
        end
      rescue ActiveStorage::FileNotFoundError
        ActionController::Base.helpers.asset_path("default_avatar.png")
      end
    else
      ActionController::Base.helpers.asset_path("default_avatar.png")
    end
  end

  validate :acceptable_avatar

  def unread_notifications_count
    notifications.where(notification_users: { is_read: false }).count
  end

  def admin?
    self.role.to_sym == :admin
  end

  def teacher?
    self.role.to_sym == :teacher
  end

  def student?
    self.role.to_sym == :student
  end

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
    self.role ||= :student
  end

  def email_or_phone_present
    if email.blank? && phone.blank?
      errors.add(:email, "邮箱和手机号码至少填写一个")
      errors.add(:phone, "邮箱和手机号码至少填写一个")
    end
  end

  def normalize_empty_strings
    self.email = nil if email.blank?
    self.phone = nil if phone.blank?
  end
end
