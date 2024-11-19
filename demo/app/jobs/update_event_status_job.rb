class UpdateEventStatusJob
  include Sidekiq::Job

  def perform
    Event.where("end_time <= ? AND status != ?", Time.current, Event.statuses[:finished]).find_each do |event|
      event.update(status: :finished)
      Rails.logger.info "Event ID #{event.id} status updated to finished."
    end
  rescue => e
    Rails.logger.error "Failed to update event statuses: #{e.message}"
  end
end