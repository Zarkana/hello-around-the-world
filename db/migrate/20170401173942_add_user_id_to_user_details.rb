class AddUserIdToUserDetails < ActiveRecord::Migration[5.0]
  def change
    # remove_column :users, :user_details_id
    add_column :user_details, :user_id, :integer
  end
end
