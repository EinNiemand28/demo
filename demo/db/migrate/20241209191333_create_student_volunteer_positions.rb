class CreateStudentVolunteerPositions < ActiveRecord::Migration[7.2]
  def change
    create_table :student_volunteer_positions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :volunteer_position, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :student_volunteer_positions, [:user_id, :volunteer_position_id], unique: true
  end
end
