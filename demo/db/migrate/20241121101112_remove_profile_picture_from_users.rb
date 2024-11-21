class RemoveProfilePictureFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :profile_picture, :string
  end
end
