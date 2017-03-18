class CreateQuizzes < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.integer :language_id
      t.integer :user_id

      t.timestamps
    end
  end
end
