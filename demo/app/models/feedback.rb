class Feedback < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
  validates :user_id, uniqueness: { scope: :event_id, message: "您已经提交过反馈。" }
  
  validate :event_must_be_finished
  validate :user_must_be_participant

  private
  def event_must_be_finished
    unless event&.finished?
      errors.add(:event, "活动尚未结束。")
    end
  end

  def user_must_be_participant
    unless event&.participants&.include?(user)
      errors.add(:user, "您不是该活动的参与者。")
    end
  end
end
