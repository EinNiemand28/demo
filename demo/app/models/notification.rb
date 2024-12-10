class Notification < ApplicationRecord
  validates :content, presence: true
  has_many :notification_users, dependent: :destroy
  has_many :users, through: :notification_users, source: :user
end
