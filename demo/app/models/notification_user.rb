class NotificationUser < ActiveRecord::Base
  belongs_to :notification
  belongs_to :user

  validates :notification_id, uniqueness: { scope: :user_id, message: "已向该用户发送通知" }

  def mark_as_read
    update(is_read: true)
  end
end