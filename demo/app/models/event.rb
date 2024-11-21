class Event < ApplicationRecord
  enum :status, { pending: 0, ongoing: 1, finished: 2, canceled: 3 }

  belongs_to :organizer_teacher, class_name: "User", foreign_key: "organizer_teacher_id"
  
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validates :status, presence: true
  validates :registration_deadline, presence: true
  validates :max_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :start_time_before_end_time
  validate :registration_deadline_before_start_time

  has_many :teacher_events, foreign_key: "event_id", dependent: :destroy
  has_many :teachers, through: :teacher_events, source: :user
  has_many :student_events, foreign_key: "event_id", dependent: :destroy
  has_many :participants, -> { where(student_events: { status: :registered }) }, through: :student_events, source: :user

  has_many :volunteer_positions, foreign_key: "event_id", dependent: :destroy
  # has_many :event_volunteer_positions, through: :volunteer_positions, source: :volunteer_position
  
  has_many :feedbacks, dependent: :destroy

  private
  def start_time_before_end_time
    if start_time >= end_time
      errors.add(:start_time, "开始时间必须早于结束时间")
    end
  end

  def registration_deadline_before_start_time
    if registration_deadline > start_time
      errors.add(:registration_deadline, "报名截止时间不得晚于开始时间")
    end
  end
end
