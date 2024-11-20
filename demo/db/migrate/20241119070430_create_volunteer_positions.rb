class CreateVolunteerPositions < ActiveRecord::Migration[7.2]
  def change
    create_table :volunteer_positions do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false, limit: 100
      t.text :description, null: false
      t.integer :required_number, null: false
      t.float :volunteer_hours, null: false
      t.datetime :registration_deadline, null: false

      t.timestamps
    end
  end
end
