class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.text :content, null: false
      t.datetime :notification_time, null: false

      t.timestamps
    end
  end
end
