namespace :events do
  desc "Update event status to finished if it's end_time is passed"
  task update_event_status: :environment do
    Event.where("end_time <= ? AND status != ?", Time.current, Event.statuses[:finished]).find_each do |event|
      event.update(status: :finished)
      puts "Event ID #{event.id} status updated to finished."
    end
  end
end