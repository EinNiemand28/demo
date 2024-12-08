# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(
  username: "root",
  email: "1@1",
  password: "123123",
  password_confirmation: '123123',
  role: :admin
)

puts "Seeded 1 admin"

20.times do |i|
  user = User.create!(
    username: "user#{i+1}",
    email: "user#{i+1}@example.com",
    phone: "1380110#{sprintf('%04d', i+1)}",
    password: '123123',
    password_confirmation: '123123',
    role: [:buyer, :buyer, :worker].sample
  )
end

puts "Seeded 20 users"