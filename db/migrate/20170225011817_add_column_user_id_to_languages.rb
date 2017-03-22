class AddColumnUserIdToLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :languages, :user_id, :integer
  end
end
