class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false
      t.boolean :is_anonymous, null: false, default: false
      t.datetime :feedback_time, null: false

      t.timestamps
    end
  end
end
