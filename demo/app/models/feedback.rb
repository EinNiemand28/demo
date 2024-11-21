class Feedback < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
  validates :user_id, uniqueness: { scope: :event_id, message: "您已经提交过反馈。" }
  # validates :feedback_time, presence: true
end
