class CreateStudentVolunteerPositions < ActiveRecord::Migration[7.2]
  def change
    create_table :student_volunteer_positions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :volunteer_position, null: false, foreign_key: true
      t.timestamp :registration_time, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
