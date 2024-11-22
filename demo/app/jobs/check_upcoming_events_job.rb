class CheckUpcomingEventsJob
  include Sidekiq::Job
  
  def perform
    Event.where(status: :upcoming)
         .where("start_time > ? AND start_time <= ?", Time.current, 1.hour.from_now)
         .find_each do |event|
      NotificationService.notify_event_start(event)
    end
  end
end