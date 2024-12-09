class CreateStudentEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :student_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.timestamp :registration_time, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :student_events, [:user_id, :event_id], unique: true
  end
end
