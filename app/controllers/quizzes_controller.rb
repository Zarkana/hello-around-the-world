class QuizzesController < ApplicationController
  def index
  end

  def new
    @quiz = Quiz.new
    if user_signed_in?
      @languages = Language.accessible_by(current_ability)
      # doesn't include snippets with categories
      # @snippets = current_user.snippets.where(category_id: nil).accessible_by(current_ability)
      # @categories = current_user.categories.includes(:snippets).where("snippets.user" => current_user).accessible_by(current_ability)
      @snippets = current_user.snippets.order('LOWER(category_id)')
      # @categories = current_user.categories
      # @snippet_categories = current_user.snippets.where.not(category_id: nil)
    else
      @admin = User.where('admin = ?', true).first

      @languages = @admin.languages
      # doesn't include snippets with categories
      # @snippets = @admin.snippets.where(category_id: nil)
      # @categories = @admin.categories.includes(:snippets).where("snippets.user" => @admin)
      @snippets = @admin.snippets.order('LOWER(category_id)')
      # @snippet_categories = @admin.categories.snippets.where("snippets.user" => @admin)
    end
    # Create the blank quiz_snippets to be available on new view
    @snippets.each do |snippet|
      quiz_snippet = @quiz.quiz_snippets.build(:snippet_id => snippet.id)
    end
    # @category_snippets.each do |snippet|
    #   category_quiz_snippet = @quiz.quiz_snippets.build(:snippet_id => snippet.id)
    # end
    # Create the blank quiz_categories to be available on new view
    # @categories.each do |category|
    #   quiz_snippet = @quiz.quiz_snippets.build(:snippet_id => snippet.id)
    # end
  end

  def create
    @quiz = Quiz.new(quiz_params)

    @quiz.user = current_user
    # authorize! :create, @quiz

    if @quiz.save
      p "Quiz saved successfully"
      @quiz.quiz_snippets.each do |quiz_snippet|
        # Get the quiz_snippets snippet and category

        snippet = Snippet.where(id: quiz_snippet.snippet_id).first
        snippet_category = Category.where(id: snippet.category_id).first
        selected_language = Language.where(id: @quiz.language_id).first

        # Get whether there is a category
        has_category = snippet_category

        # Check if both are active
        if (has_category && snippet_category.active) || !has_category
          p "category is active or there is no category"
          if snippet.active
            p "snippet is active"

            # Set the quiz_snippets answer to the implementations code that has the same name as the selected language
            quiz_snippet.answer = snippet.implementations.where(language: selected_language.name).first.code
            quiz_snippet.title = "#{snippet.title} in #{selected_language.name}"
            quiz_snippet.quiz_id = @quiz.id

            if quiz_snippet.save
                p "Quiz Snippet saved successfully"
                p "QUIZ SNIPPET"
                p quiz_snippet.inspect
            else
              p "Quiz Snippet saved unsuccessfully"
            end
          else
            p "snippet not active"
          end
        else
          p "category not active"
        end
      end

      redirect_to action: 'question', id: @quiz.id
      return
    else
      p "Quiz saved unsuccessfully"
    end
    redirect_to action: 'new'
    return
  end

  def manage
  end

  def question
    @quiz = Quiz.find(params[:id])
    @quiz_snippets = @quiz.quiz_snippets
    @language = Language.find(@quiz.language_id)
  end

  def answer
  end

  private
    def quiz_params
      params.require(:quiz).permit(:language_id, :user_id, :complete, quiz_snippets_attributes:[:attempt, :answer, :title, :quiz_id, :snippet_id, :_destroy])
    end

end
