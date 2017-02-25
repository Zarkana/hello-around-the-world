class QuizController < ApplicationController
  def index
    @snippets = Snippet.accessible_by(current_ability)
    @singleSnippets = Snippet.where(category_id: nil).accessible_by(current_ability)
    @categories = Category.includes(:snippets).accessible_by(current_ability)
    @multiSnippets = Snippet.where.not(category_id: nil).accessible_by(current_ability)

  end

  def question
  end

  def answer
  end
end
