class CheckUpcomingEventsJob
  include Sidekiq::Job
  
  def perform
    Event.where(status: :upcoming)
         .where("start_time > ? AND start_time <= ?", Time.current, 1.hour.from_now)
         .find_each do |event|
      NotificationService.notify_event_start(event)
      Rails.logger.info "Sent start notification for Event ID #{event.id}"
    end
  rescue => e
    Rails.logger.error "Failed to check upcoming events: #{e.message}"
    raise
  end
end