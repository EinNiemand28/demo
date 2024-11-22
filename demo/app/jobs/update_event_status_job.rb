class UpdateEventStatusJob
  include Sidekiq::Job

  def perform
    Event.where("start_time <= ? AND status = ?", Time.current, Event.statuses[:upcoming]).find_each do |event|
      event.update(status: :ongoing)
      Rails.logger.info "Event ID #{event.id} status updated to ongoing."
    end
    Event.where("end_time <= ?", Time.current).find_each do |event|
      if event.status == "ongoing"
        event.update(status: :finished)
        Rails.logger.info "Event ID #{event.id} status updated to finished."
        update_volunteer_hours(event)
        NotificationService.notify_event_feedback(event)
      elsif event.status == "pending"
        event.update(status: :canceled)
        Rails.logger.info "Event ID #{event.id} status updated to canceled."
      end
    end
  rescue => e
    Rails.logger.error "Failed to update event statuses: #{e.message}"
  end

  private

  def update_volunteer_hours(event)
    event.volunteer_positions.each do |position|
      hours = position.volunteer_hours
      position.volunteers.each do |volunteer|
        volunteer.with_lock do 
          volunteer.update!(volunteer_hours: volunteer.volunteer_hours + hours)
        end
        Rails.logger.info "Volunteer ID #{volunteer.id} hours updated to #{volunteer.volunteer_hours}."
      end
    end
  rescue => e
    Rails.logger.error "Failed to update volunteer hours for event #{event.id}: #{e.message}"
  end
end