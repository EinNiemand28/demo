class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 50
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.string :image, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :name
  end
end
