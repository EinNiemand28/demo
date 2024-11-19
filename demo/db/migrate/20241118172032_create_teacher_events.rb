class CreateTeacherEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :teacher_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
    add_index :teacher_events, [:user_id, :event_id], unique: true
  end
end
