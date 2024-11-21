class StudentVolunteerPosition < ApplicationRecord
  belongs_to :user
  belongs_to :volunteer_position

  enum :status, { :pending => 0, :approved => 1, :canceled => 2 }

  validates :user_id, uniqueness: { scope: :volunteer_position_id, message: "已申请该志愿者岗位" }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
