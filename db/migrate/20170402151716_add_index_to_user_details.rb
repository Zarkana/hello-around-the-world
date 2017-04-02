class AddIndexToUserDetails < ActiveRecord::Migration[5.0]
  def change
    add_index :user_details, :user_id
  end
end
