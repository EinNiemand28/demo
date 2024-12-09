json.extract! event, :id, :title, :description, :start_time, :end_time, :location, :status, :registration_deadline, :max_participants, :created_at, :updated_at
json.url event_url(event, format: :json)
