class VolunteerPosition < ApplicationRecord
  belongs_to :event
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :required_number, numericality: { only_integer: true, greater_than: 0 }
  validates :volunteer_hours, numericality: { greater_than: 0.0 }
  validates :registration_deadline, presence: true

  validate :registration_deadline_before_start_time
  validate :required_number_not_less_than_registered
  validate :name_unique_within_event

  has_many :student_volunteer_positions, dependent: :destroy
  has_many :volunteers, -> { where(student_volunteer_positions: { status: :approved }) }, through: :student_volunteer_positions, source: :user

  after_update :notify_changes



  private
  def notify_changes
    changed_fields = []
    changed_fields << "名称" if saved_change_to_name?
    changed_fields << "描述" if saved_change_to_description?
    changed_fields << "志愿者时长" if saved_change_to_volunteer_hours?

    NotificationService.notify_volunteer_position_updated(self, changed_fields) if changed_fields.any?
  end

  def registration_deadline_before_start_time
    if registration_deadline >= event.start_time
      errors.add(:registration_deadline, "申请截止时间必须早于活动开始时间")
    end
  end

  def required_number_not_less_than_registered
    if student_volunteer_positions.approved.count > required_number
      errors.add(:required_number, "所需志愿者人数不能少于已通过审核的志愿者人数")
    end
  end

  def name_unique_within_event
    if event.volunteer_positions.where.not(id: id).exists?(name: name)
      errors.add(:name, "该活动中已存在同名的志愿者岗位")
    end
  end
end
