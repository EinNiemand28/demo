# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_22_024340) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "event_volunteer_positions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "volunteer_position_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_volunteer_positions_on_event_id"
    t.index ["volunteer_position_id"], name: "index_event_volunteer_positions_on_volunteer_position_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.text "description", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "location", null: false
    t.bigint "organizer_teacher_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "registration_deadline", null: false
    t.integer "max_participants", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_teacher_id"], name: "index_events_on_organizer_teacher_id"
  end

  create_table "feedbacks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "comment", null: false
    t.boolean "is_anonymous", default: false, null: false
    t.datetime "feedback_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_feedbacks_on_event_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "notification_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.bigint "user_id", null: false
    t.boolean "is_read", default: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id", "user_id"], name: "index_notification_users_on_notification_id_and_user_id", unique: true
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
    t.index ["user_id"], name: "index_notification_users_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "notification_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.timestamp "registration_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_student_events_on_event_id"
    t.index ["user_id", "event_id"], name: "index_student_events_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_student_events_on_user_id"
  end

  create_table "student_volunteer_positions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "volunteer_position_id", null: false
    t.timestamp "registration_time", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_student_volunteer_positions_on_user_id"
    t.index ["volunteer_position_id"], name: "index_student_volunteer_positions_on_volunteer_position_id"
  end

  create_table "teacher_events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_teacher_events_on_event_id"
    t.index ["user_id", "event_id"], name: "index_teacher_events_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_teacher_events_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", limit: 100, default: ""
    t.string "telephone", default: ""
    t.string "password"
    t.float "volunteer_hours", default: 0.0
    t.integer "role_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteer_positions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", limit: 100, null: false
    t.text "description", null: false
    t.integer "required_number", null: false
    t.float "volunteer_hours", null: false
    t.datetime "registration_deadline", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_volunteer_positions_on_event_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_volunteer_positions", "events"
  add_foreign_key "event_volunteer_positions", "volunteer_positions"
  add_foreign_key "events", "users", column: "organizer_teacher_id"
  add_foreign_key "feedbacks", "events"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "notification_users", "notifications"
  add_foreign_key "notification_users", "users"
  add_foreign_key "student_events", "events"
  add_foreign_key "student_events", "users"
  add_foreign_key "student_volunteer_positions", "users"
  add_foreign_key "student_volunteer_positions", "volunteer_positions"
  add_foreign_key "teacher_events", "events"
  add_foreign_key "teacher_events", "users"
  add_foreign_key "volunteer_positions", "events"
end
