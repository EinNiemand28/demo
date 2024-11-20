class CreateEventVolunteerPositions < ActiveRecord::Migration[7.2]
  def change
    create_table :event_volunteer_positions do |t|
      t.references :event, null: false, foreign_key: true
      t.references :volunteer_position, null: false, foreign_key: true

      t.timestamps
    end
  end
end
