class Application < ApplicationRecord
  belongs_to :applicant, class_name: "User"
  belongs_to :event, optional: true

  enum :status, { :pending => 0, :approved => 1, :rejected => 2 }

  def pending?
    status.to_sym == :pending
  end

  def approved?
    status.to_sym == :approved
  end

  def rejected?
    status.to_sym == :rejected
  end

  validates :title, presence: true, length: { maximum: 50 }
  validates :plan, presence: true
end