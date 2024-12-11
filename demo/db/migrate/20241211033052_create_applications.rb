class CreateApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :applications do |t|
      t.string :title, null: false, limit: 100
      t.text :plan, null: false
      t.integer :status, null: false, default: 0
      t.references :applicant, null: false, foreign_key: { to_table: :users }
      t.datetime :approved_at
      t.text :comment
      t.references :event, foreign_key: true

      t.timestamps
    end
    add_index :applications, :status
  end
end
