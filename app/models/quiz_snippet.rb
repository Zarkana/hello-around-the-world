class QuizSnippet < ApplicationRecord
  belongs_to :quiz, inverse_of: :quiz_snippets
  belongs_to :snippet
end
