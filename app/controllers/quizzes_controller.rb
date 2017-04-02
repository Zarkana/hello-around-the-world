class QuizzesController < ApplicationController
  def index
  end

  def new
    @quiz = Quiz.new

    if user_signed_in?
      @languages = Language.accessible_by(current_ability)
      @snippets = current_user.snippets.order('category_id')

      user_detail = UserDetail.find_by(user_id: current_user.id)
      if !user_detail.blank?
        @last_language = Language.find_by_id(current_user.user_detail.last_language_id)
        if !@last_language.blank?
          @last_language_id = @last_language.id
          @last_language_name = @last_language.name
        else
          @last_language_id = ""
          @last_language_name = "What?"          
        end
        @difficulty = current_user.user_detail.last_difficulty
      else
        @last_language_id = ""
        @last_language_name = "What?"
        @difficulty = 0.0
      end

    else
      @admin = User.where('admin = ?', true).first

      @languages = @admin.languages
      @snippets = @admin.snippets.order('category_id')

      @last_language_id = ""
      @last_language_name = "What?"
      @difficulty = 0.0
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
      # update default language and difficulty
      p "updating user"
      user_detail = UserDetail.where(user_id: current_user.id).first_or_create(:last_language_id => @quiz.language_id, :last_difficulty => @quiz.difficulty)
      # current_user.user_detail = user_detail
      user_detail.update_attributes(
        :last_language_id => @quiz.language_id,
        :last_difficulty => @quiz.difficulty
      )
      #
      # current_user.update_attributes(
      #   :user_detail => user_detail
      # )

    else
      @quiz.user = User.where('admin = ?', true).first
    end

    p "Quiz Difficulty"
    p @quiz.difficulty

    # authorize! :create, @quiz
    if @quiz.language_id
      p "Language exists"
    else
      p "Language does not exist"
      build_quiz_snippets

      @errors = @quiz.errors
      @errors[:language] << "You need to select a language to quiz on."
      render 'new'
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

        # if !@snippet.blank?
          # TODO: snippets need answers
          # implementation = Implementation.where(snippet_id: @snippet.id).where(language_id: @languages[f.options[:child_index]].id).first
          p "Snippet not blank"

          p "The selected language id"
          p selected_language.id

          quiz_implementation = snippet.implementations.find_by(:language_id => selected_language.id)
          unless quiz_implementation.blank?
            quiz_snippet.answer = quiz_implementation.code
            p "The Answer"
            p quiz_snippet.answer.inspect
          end
          quiz_snippet.attempt = hint_builder(quiz_snippet)
        # end
        # quiz_snippet.answer = snippet.implementations.where(language_id: selected_language.id).first.code

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
    build_quiz_snippets

    @errors = @quiz.errors
    render 'new'
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
    @quiz.complete = true;

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
    def build_quiz_snippets(quiz)
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

    def hint_builder(quiz_snippet)
      p "Difficulty Builder"
      attempt_hint = quiz_snippet.answer
      total_chars = attempt_hint.size
      total_chars_to_remove = (@quiz.difficulty / 100 ) * total_chars
      hint_lines = attempt_hint.split(/\n+/)
      complete_hint = ""
      random_order = (0..(hint_lines.length-1)).to_a.shuffle

      random_order.each do |rand_index|
        line_size = hint_lines[rand_index].size
        line_white_space = hint_lines[rand_index][/^\s+/]
        hint_lines[rand_index] = "#{line_white_space}# HIDDEN LINE\n"

        total_chars_to_remove -= line_size
        break if total_chars_to_remove <= 0
      end

      hint_lines.each do |hint|
        complete_hint << hint
      end
      complete_hint
    end

    def update_user
      # user_detail = UserDetail.where(user_id: current_user.id).first_or_create(:last_language_id => @quiz.language_id, :last_difficulty => @quiz.difficulty)
      # current_user.user_detail = user_detail
      # p "user details are ->"
      # p user_details.inspect
      # # If no user or current_user is not admin
      # # if !current_user.admin
      # #   return
      # # end
      # # if current_user.default_language
      # p "updating user"
      # p "new last language id"
      # p @quiz.language_id
      # user_details.update_attributes(
      #   :last_language_id => @quiz.language_id
      # )
      # # end
      # # if current_user.default_difficulty
      # p "new quiz difficulty"
      # p @quiz.difficulty
      #
      # user_details.update_attributes(
      #   :last_difficulty => @quiz.difficulty
      # )
      # p "the error"
      # p current_user.errors.full_messages.inspect

      # end
    end

    def quiz_params
      params.require(:quiz).permit(:language_id, :user_id, :complete, :difficulty, quiz_snippets_attributes:[:attempt, :answer, :title, :quiz_id, :snippet_id, :_destroy])
    end
    def quiz_update_params
      params.require(:quiz).permit(:language_id, :user_id, :complete, quiz_snippets_attributes:[:id, :attempt, :answer, :title, :quiz_id, :snippet_id, :_destroy])
    end
end
