class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 50
      t.string :email, default: "", limit: 100
      t.string :telephone, default: ""
      t.string :password
      t.float :volunteer_hours, default: 0.0
      t.string :profile_picture, default: "default_avatar.png"
      t.integer :role_level, default: 0

      t.timestamps
    end
  end
end
