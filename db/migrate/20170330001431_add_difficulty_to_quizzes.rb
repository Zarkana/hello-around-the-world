class AddDifficultyToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :difficulty, :float, default: 0.0
  end
end
