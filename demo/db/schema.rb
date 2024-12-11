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

ActiveRecord::Schema[7.2].define(version: 2024_12_11_033052) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.text "plan", null: false
    t.integer "status", default: 0, null: false
    t.bigint "applicant_id", null: false
    t.datetime "approved_at"
    t.text "comment"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
    t.index ["event_id"], name: "index_applications_on_event_id"
    t.index ["status"], name: "index_applications_on_status"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.text "description", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "location", null: false
    t.bigint "organizing_teacher_id", null: false
    t.integer "status", default: 0
    t.datetime "registration_deadline", null: false
    t.integer "max_participants", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_time"], name: "index_events_on_end_time"
    t.index ["organizing_teacher_id"], name: "index_events_on_organizing_teacher_id"
    t.index ["registration_deadline"], name: "index_events_on_registration_deadline"
    t.index ["start_time"], name: "index_events_on_start_time"
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "feedbacks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "comment", null: false
    t.boolean "is_anonymous", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "user_id"], name: "index_feedbacks_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_feedbacks_on_event_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "notification_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.bigint "user_id", null: false
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id", "user_id"], name: "index_notification_users_on_notification_id_and_user_id", unique: true
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
    t.index ["user_id"], name: "index_notification_users_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "student_events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.timestamp "registration_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_student_events_on_event_id"
    t.index ["user_id", "event_id"], name: "index_student_events_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_student_events_on_user_id"
  end

  create_table "student_volunteer_positions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "volunteer_position_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "volunteer_position_id"], name: "idx_on_user_id_volunteer_position_id_356656925a", unique: true
    t.index ["user_id"], name: "index_student_volunteer_positions_on_user_id"
    t.index ["volunteer_position_id"], name: "index_student_volunteer_positions_on_volunteer_position_id"
  end

  create_table "teacher_events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_teacher_events_on_event_id"
    t.index ["user_id", "event_id"], name: "index_teacher_events_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_teacher_events_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "username", limit: 50, null: false
    t.string "email", limit: 50
    t.string "phone", limit: 25
    t.integer "role", default: 0
    t.float "volunteer_hours", default: 0.0
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "volunteer_positions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", limit: 100, null: false
    t.text "description", null: false
    t.integer "required_number", null: false
    t.float "volunteer_hours", null: false
    t.datetime "registration_deadline", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "name"], name: "index_volunteer_positions_on_event_id_and_name", unique: true
    t.index ["event_id"], name: "index_volunteer_positions_on_event_id"
    t.index ["registration_deadline"], name: "index_volunteer_positions_on_registration_deadline"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applications", "events"
  add_foreign_key "applications", "users", column: "applicant_id"
  add_foreign_key "events", "users", column: "organizing_teacher_id"
  add_foreign_key "feedbacks", "events"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "notification_users", "notifications"
  add_foreign_key "notification_users", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "student_events", "events"
  add_foreign_key "student_events", "users"
  add_foreign_key "student_volunteer_positions", "users"
  add_foreign_key "student_volunteer_positions", "volunteer_positions"
  add_foreign_key "teacher_events", "events"
  add_foreign_key "teacher_events", "users"
  add_foreign_key "volunteer_positions", "events"
end
