json.extract! user, :id, :name, :email, :telephone, :password, :volunteer_hours, :profile_picture, :role_level, :created_at, :updated_at
json.url user_url(user, format: :json)
