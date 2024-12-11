class UpdateEventStatusJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform
    update_to_ongoing
    update_finished_and_canceled
  rescue => e
    Rails.logger.error "Failed to update event status: #{e.message}"
    raise
  end

  private
  def update_to_ongoing
    Event.where(status: :upcoming)
         .where("start_time <= ?", Time.current)
         .find_each do |event|
      event.with_lock do
        event.update!(status: :ongoing)
        Rails.logger.info "Event ID #{event.id} status updated to ongoing."
      end
    end
  end

  def update_finished_and_canceled
    Event.where("end_time <= ?", Time.current)
         .where(status: [:ongoing, :draft])
         .find_each do |event|
      event.with_lock do
        if event.ongoing?
          update_finished_event(event)
        elsif event.draft?
          update_canceled_event(event)
        end
      end
    end
  end

  def update_finished_event(event)
    event.update!(status: :finished)
    Rails.logger.info "Event ID #{event.id} status updated to finished."

    update_volunteer_hours(event)
    NotificationService.notify_event_feedback(event)
  end

  def update_canceled_event(event)
    event.update!(status: :canceled)
    Rails.logger.info "Event ID #{event.id} status updated to canceled."
  end

  def update_volunteer_hours(event)
    event.volunteer_positions.includes(:volunteers).each do |position|
      position.volunteers.each do |volunteer|
        volunteer.with_lock do
          current_hours = volunteer.volunteer_hours || 0
          volunteer.update!(volunteer_hours: current_hours + position.volunteer_hours)
          Rails.logger.info "Volunteer ID #{volunteer.id} hours updated: +#{position.volunteer_hours}"
        end
      end
    end
  rescue => e
    Rails.logger.error "Failed to update volunteer hours for event #{event.id}: #{e.message}"
    raise
  end
end