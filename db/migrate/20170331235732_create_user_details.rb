class CreateUserDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :user_details do |t|
      t.float :last_difficulty, default: 0.0
      t.integer :last_language_id

      t.timestamps
    end
  end
end
