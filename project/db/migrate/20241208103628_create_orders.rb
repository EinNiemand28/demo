class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.integer :status
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
