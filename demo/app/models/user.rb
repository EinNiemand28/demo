class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "请输入正确的邮箱地址" }, allow_blank: true, length: { maximum: 100 }
  validates :telephone, uniqueness: true, format: { with: /\A1[3-9]\d{9}\z/, message: "请输入正确的手机号码" }, allow_blank: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validate :email_or_telephone_present

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_teacher_id", dependent: :destroy
  has_many :teacher_events, foreign_key: "user_id", dependent: :destroy
  has_many :associated_events, through: :teacher_events, source: :event

  has_many :student_events, foreign_key: "user_id", dependent: :destroy
  has_many :registered_events, -> { where(student_events: { status: :registered }) }, through: :student_events, source: :event

  has_many :student_volunteer_positions, foreign_key: "user_id", dependent: :destroy
  has_many :registered_volunteer_positions, -> { where(student_volunteer_positions: { status: :approved }) }, through: :student_volunteer_positions, source: :volunteer_position

  has_many :feedbacks, dependent: :destroy

  enum :role_level, { student: 0, teacher: 1, admin: 2 }
  after_initialize :set_default_role, if: :new_record?

  has_one_attached :avatar_picture do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validate :acceptable_avatar_picture

  attr_writer :login

  def login
    @login || self.email || self.telephone
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(email) = :value OR lower(telephone) = :value", { value: login.downcase }]).first
    elsif conditions.key?(:email) || conditions.key?(:telephone)
      where(conditions.to_h).first
    end
  end

  def set_default_role
    self.role_level ||= :student
  end

  def admin?
    self.role_level == "admin"
  end

  def teacher?
    self.role_level == "teacher"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "id", "name", "telephone", "role_level"]
  end

  def contact_info
    if telephone.present?
      telephone
    else
      email
    end
  end

  private

  def email_or_telephone_present
    if email.blank? && telephone.blank?
      errors.add(:base, "邮箱和手机号码至少填写一个")
    end
  end

  def acceptable_avatar_picture
    return unless avatar_picture.attached?

    unless avatar_picture.blob.byte_size <= 5.megabytes
      errors.add(:avatar_picture, "图片大小不能超过5MB")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(avatar_picture.content_type)
      errors.add(:avatar_picture, "图片格式必须为 JPEG 或 PNG ")
    end
  end
end
