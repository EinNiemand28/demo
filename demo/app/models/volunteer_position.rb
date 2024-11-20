class VolunteerPosition < ApplicationRecord
  belongs_to :event
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :required_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :volunteer_hours, numericality: { greater_than_or_equal_to: 0.0 }
  validates :registration_deadline, presence: true

  validate :registration_deadline_before_start_time

  has_many :student_volunteer_positions, dependent: :destroy
  has_many :volunteers, -> { where(student_volunteer_positions: { status: :approved }) }, through: :student_volunteer_positions, source: :user

  private

  def registration_deadline_before_start_time
    if registration_deadline >= event.start_time
      errors.add(:registration_deadline, "申请截止时间必须早于活动开始时间")
    end
  end
end
