class UpdateEventStatusJob
  include Sidekiq::Job

  def perform
    Event.where("end_time <= ?", Time.current).find_each do |event|
      if event.status == "ongoing"
        event.update(status: :finished)
        Rails.logger.info "Event ID #{event.id} status updated to finished."
        # TODO: send notification to participants
      elsif event.status == "pending"
        event.update(status: :canceled)
      end
    end
  rescue => e
    Rails.logger.error "Failed to update event statuses: #{e.message}"
  end
end