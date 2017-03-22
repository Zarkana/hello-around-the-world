class QuizzesController < ApplicationController
  def index
  end

  def new
    @quiz = Quiz.new
    if user_signed_in?
      @languages = Language.accessible_by(current_ability)
      @snippets = current_user.snippets.order('category_id')
    else
      @admin = User.where('admin = ?', true).first

      @languages = @admin.languages
      @snippets = @admin.snippets.order('category_id')
    end
    # Create the blank quiz_snippets to be available on new view
    @snippets.each do |snippet|
      quiz_snippet = @quiz.quiz_snippets.build(:snippet_id => snippet.id)
    end
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if user_signed_in?
      @quiz.user = current_user
    else
      @quiz.user = User.where('admin = ?', true).first
    end

    # authorize! :create, @quiz
    if @quiz.language_id
      p "Language exists"
    else
      p "Language does not exist"
      redirect_to action: 'new'
      return
    end

    # Set the quiz_snippets answer to the implementations code that has the same name as the selected language
    @quiz.quiz_snippets.each do |quiz_snippet|
      unless quiz_snippet.snippet_id.nil?
        # todo: please fix this
        p "THE QUIZ SNIPPET"
        p quiz_snippet.inspect

        snippet = Snippet.where(id: quiz_snippet.snippet_id).first
        p "The Snippet"
        p snippet.inspect
        selected_language = Language.where(id: @quiz.language_id).first
        p "The Language"
        p selected_language.inspect

        quiz_snippet.answer = snippet.implementations.where(language_id: selected_language.id).first.code

        p "The Answer"
        p quiz_snippet.answer.inspect

        quiz_snippet.title = "#{snippet.title} in #{selected_language.name}"
        quiz_snippet.quiz_id = @quiz.id

      else
        p "nil quiz_snippet.snippet_id"
        quiz_snippet.delete()
        # TODO: This is really weird and absolutely needs to be fixed
        # Currently getting a number of empty quiz_snippets and just deleting them after
      end
    end

    if @quiz.save
      p "Quiz saved successfully"
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

  def update
    @quiz = Quiz.find(params[:id])

    if @quiz.update(quiz_update_params)
      # authorize! :update, @quiz
      p "Quiz updated successfully"
      redirect_to action: 'answer', id: @quiz.id
      return
    else
      p "Quiz updated unsuccessfully"
      redirect_to action: 'question', id: @quiz.id
      return
    end
  end

  def answer
    @quiz = Quiz.find(params[:id])
    @quiz_snippets = @quiz.quiz_snippets
    @language = Language.find(@quiz.language_id)
  end

  private
    def quiz_params
      params.require(:quiz).permit(:language_id, :user_id, :complete, quiz_snippets_attributes:[:attempt, :answer, :title, :quiz_id, :snippet_id, :_destroy])
    end
    def quiz_update_params
      params.require(:quiz).permit(:language_id, :user_id, :complete, quiz_snippets_attributes:[:id, :attempt, :answer, :title, :quiz_id, :snippet_id, :_destroy])
    end
end
