class QuizController < ApplicationController
  def index
    @snippets = Snippet.all
    @singleSnippets = Snippet.where(category_id: nil)
    @categories = Category.includes(:snippets)
    @multiSnippets = Snippet.where.not(category_id: nil)

  end

  def question
  end

  def answer
  end
end
