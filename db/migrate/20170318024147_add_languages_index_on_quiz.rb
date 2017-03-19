class AddLanguagesIndexOnQuiz < ActiveRecord::Migration[5.0]
  def change
    add_index :quizzes, :language_id
  end
end
