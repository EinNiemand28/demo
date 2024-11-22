class CreateNotificationUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_users do |t|
      t.references :notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_read, default: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :notification_users, [:notification_id, :user_id], unique: true
  end
end
