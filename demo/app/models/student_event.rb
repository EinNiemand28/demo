class StudentEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { 
    scope: :event_id, 
    message: "已报名该活动。" 
  }

  validate :user_must_be_student

  private
  def user_must_be_student
    unless user&.student?
      errors.add(:user, "必须是学生")
    end
  end
end
