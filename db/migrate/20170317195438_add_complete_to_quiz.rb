class AddCompleteToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :complete, :boolean, default: false
  end
end
