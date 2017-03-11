class QuizController < ApplicationController
  def index
    # Need to use after_database_authentication to add admin data to new user. Otherwise no editing, or active.
    # if User.exists?(admin: true)
    #   @admin = User.where('admin = ?', true).first
    #   @adminSnippets = Snippet.where('user_id = ?', @admin.id)
    #   @adminSingleSnippets = Snippet.where(category_id: nil).where('user_id = ?', @admin.id)
    #   @adminCategories = Category.includes(:snippets).where('user_id= ?', @admin.id)
    #   @adminMultiSnippets = Snippet.where.not(category_id: nil).where('user_id = ?', @admin.id)
    # end
    # If signed in
    if user_signed_in?
      # If not admin
      # unless current_user.admin == true
        # TODO: check to see if we use this
        @snippets = Snippet.accessible_by(current_ability)
        @singleSnippets = Snippet.where(category_id: nil).accessible_by(current_ability)
        # @categories = Category.includes(:snippets).accessible_by(current_ability)
        @categories = current_user.categories.includes(:snippets).where("snippets.user" => current_user).accessible_by(current_ability)
        @multiSnippets = Snippet.where.not(category_id: nil).accessible_by(current_ability)
      # end
    end
  end

  def manage
  end

  def question
  end

  def answer
  end
end
