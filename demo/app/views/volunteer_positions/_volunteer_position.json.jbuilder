json.extract! volunteer_position, :id, :event_id, :name, :description, :required_number, :volunteer_hours, :registration_deadline, :created_at, :updated_at
json.url volunteer_position_url(volunteer_position, format: :json)
