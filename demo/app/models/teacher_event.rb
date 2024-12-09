class TeacherEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { 
    scope: :event_id, 
    message: "已关联该活动" 
  }

  validate :user_must_be_teacher
  
  private
  
  def user_must_be_teacher
    unless user&.teacher?
      errors.add(:user, "必须是教师")
    end
  end
end
