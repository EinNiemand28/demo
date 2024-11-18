class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "请输入正确的邮箱地址" }, allow_blank: true, length: { maximum: 100 }
  validates :telephone, uniqueness: true, format: { with: /\A1[3-9]\d{9}\z/, message: "请输入正确的手机号码" }, allow_blank: true
  validates :password, presence: true
  validate :email_or_telephone_present
  validates :role_level, inclusion: { in: 0..2 }

  enum role_level: { student: 0, teacher: 1, admin: 2 }
  after_initialize :set_default_role, if: :new_record?

  has_one_attached :profile_picture

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

  private

  def email_or_telephone_present
    if email.blank? && telephone.blank?
      errors.add(:base, "邮箱和手机号码至少填写一个")
    end
  end
end
