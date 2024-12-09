class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :user_agent, :ip_address
  attribute :user

  # delegate :user, to: :session, allow_nil: true

  def reset
    super
    RequestStore.clear!
  end
end
