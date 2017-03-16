class QuizController < ApplicationController
  def index
    # Need to use after_database_authentication to add admin data to new user. Otherwise no editing, or active.
    # if User.exists?(admin: true)
    #   @admin = User.where('admin = ?', true).first
    #   # @adminSnippets = Snippet.where('user_id = ?', @admin.id)
    #   @adminSnippets = Snippet.where(category_id: nil).where('user_id = ?', @admin.id)
    #   @adminCategories = Category.includes(:snippets).where('user_id= ?', @admin.id)
    #   # @adminMultiSnippets = Snippet.where.not(category_id: nil).where('user_id = ?', @admin.id)
    # end
    # If signed in

    # Include languages so that when errors redirect to new it won't error

    if user_signed_in?

      @languages = Language.accessible_by(current_ability)
      # If not admin, because we don't want to display duplicate
      # unless current_user.admin == true
      #   @admin = User.where('admin = ?', true).first
      #   # @adminSnippets = Snippet.where('user_id = ?', @admin.id)
      #   @adminSnippets = Snippet.where(category_id: nil).where('user_id = ?', @admin.id)
      #   @adminCategories = Category.includes(:snippets).where('user_id= ?', @admin.id)
      # end
      # @snippets = current_user.snippets.accessible_by(current_ability)
      @snippets = current_user.snippets.where(category_id: nil).accessible_by(current_ability)
      # @categories = Category.includes(:snippets).accessible_by(current_ability)
      @categories = current_user.categories.includes(:snippets).where("snippets.user" => current_user).accessible_by(current_ability)
      # @multiSnippets = current_user.snippets.where.not(category_id: nil).accessible_by(current_ability)
    else
      @admin = User.where('admin = ?', true).first
      # @adminSnippets = Snippet.where('user_id = ?', @admin.id)
      @adminSnippets = @admin.snippets.where(category_id: nil)
      @adminCategories = @admin.categories.includes(:snippets).where("snippets.user" => @admin)

      @languages = @admin.languages
    end

  end

  def manage
  end

  def question
  end

  def answer
  end
end
