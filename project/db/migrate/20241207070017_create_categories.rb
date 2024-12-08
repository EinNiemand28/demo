class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 20
      t.text :description
      t.integer :parent_id

      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :parent_id
  end
end
