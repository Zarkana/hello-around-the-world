class QuizSnippet < ApplicationRecord
  belongs_to :quiz, inverse_of: :quiz_snippets

  validates :snippet_id, presence: true

  belongs_to :snippet
end
