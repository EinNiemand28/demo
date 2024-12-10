class Event < ApplicationRecord
  enum :status, { :pending => 0, :upcoming => 1, :ongoing => 2, :finished => 3, :canceled => 4 }
  validate :valid_status_transition, if: :status_changed?

  belongs_to :organizing_teacher, class_name: "User", foreign_key: "organizing_teacher_id"
  
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validates :status, presence: true
  validates :registration_deadline, presence: true
  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }

  validate :start_time_before_end_time
  validate :registration_deadline_before_start_time

  validate :max_participants_not_less_than_registered

  has_many :teacher_events, foreign_key: "event_id", dependent: :destroy
  has_many :teachers, through: :teacher_events, source: :user
  has_many :student_events, foreign_key: "event_id", dependent: :destroy
  has_many :participants, through: :student_events, source: :user

  has_many :volunteer_positions, foreign_key: "event_id", dependent: :destroy
  has_many :event_volunteer_positions, through: :volunteer_positions, source: :volunteer_position
  
  has_many :feedbacks, dependent: :destroy

  # after_update :notify_changes

  def finished?
    status.to_sym == :finished
  end

  def canceled?
    status.to_sym == :canceled
  end

  def can_delete?
    finished? || canceled?
  end

  private

  def notify_changes
    changed_fields = []
    changed_fields << "开始时间" if saved_change_to_start_time?
    changed_fields << "结束时间" if saved_change_to_end_time?
    changed_fields << "地点" if saved_change_to_location?
    # changed_fields << "状态" if saved_change_to_status?

    NotificationService.notify_event_update(self, changed_fields) if changed_fields.any?
  end
  
  def valid_status_transition
    case status_was.to_sym
    when :pending
      unless [:upcoming, :canceled].include?(status.to_sym)
        errors.add(:status, "待审核状态只能变更为即将开始或已取消")
      end
    when :upcoming
      unless [:ongoing, :canceled].include?(status.to_sym)
        errors.add(:status, "即将开始状态只能变更为进行中或已取消")
      end
    when :ongoing
      unless [:finished, :canceled].include?(status.to_sym)
        errors.add(:status, "进行中状态只能变更为已结束或已取消")
      end
    when :finished, :canceled
      errors.add(:status, "已结束或已取消状态不可再变更")
    end
  end

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

  def max_participants_not_less_than_registered
    if max_participants < participants.count
      errors.add(:max_participants, "报名人数上限不得低于已报名人数")
    end
  end
end
