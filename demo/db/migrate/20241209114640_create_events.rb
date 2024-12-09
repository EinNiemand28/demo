class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title, null: false, limit: 100
      t.text :description, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :location, null: false
      t.references :organizing_teacher, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0
      t.datetime :registration_deadline, null: false
      t.integer :max_participants, null: false

      t.timestamps
    end
    add_index :events, :status
    add_index :events, :start_time
    add_index :events, :end_time
    add_index :events, :registration_deadline
  end
end
