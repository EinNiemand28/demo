class EventVolunteerPosition < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer_position

  validates :event_id, uniqueness: { scope: :volunteer_position_id, message: "和志愿者岗位的组合必须唯一" }
end
