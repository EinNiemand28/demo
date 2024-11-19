class StudentEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { registered: 0, canceled: 1 }

  validates :user_id, uniqueness: { scope: :event_id, message: "已报名该活动。" }
end
