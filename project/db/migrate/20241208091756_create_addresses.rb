class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone, null: false
      t.string :postcode, null: false
      t.text :content, null: false
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
