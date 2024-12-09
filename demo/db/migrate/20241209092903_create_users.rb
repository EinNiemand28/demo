class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 50
      t.string :email, limit: 50, null: true
      t.string :phone, limit: 25, null: true
      t.integer :role, default: 0
      t.float :volunteer_hours, default: 0.0
      t.string :password_digest, null: false

      t.boolean :verified, null: false, default: false

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true, where: "email IS NOT NULL"
    add_index :users, :phone, unique: true, where: "phone IS NOT NULL"
  end
end
