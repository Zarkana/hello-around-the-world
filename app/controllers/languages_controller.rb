class LanguagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @languages = Language.accessible_by(current_ability)
  end

  def show
    # @language = Language.find(params[:id])
    redirect_to languages_path
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.new(language_params)
    @language.user = current_user
    @language.default = false
    authorize! :create, @language

    if @language.save

      #If admin we need to store data to be used later for default language look up
      if current_user.admin == true
        @language.default = true;
        @language.update_attributes(
          :default => true,
          :default_id => @language.id
          )
      end

      @languages = Language.accessible_by(current_ability)
      redirect_to languages_path
    else
      @language.errors.delete(:logo_file_size)
      @errors = @language.errors
      render 'new'
    end
  end

  def edit
    @language = Language.find(params[:id])
    authorize! :edit, @language
  end

  def update
    @language = Language.find(params[:id])

    if @language.update(language_params)
      @languages = Language.accessible_by(current_ability)
      authorize! :update, @language

      redirect_to languages_path
    else
      @errors = @language.errors
      render 'edit'
    end
  end

  def destroy
    @language = Language.find(params[:id])

    # Get an array of the ids of the current_users snippets
    snippet_ids = current_user.snippets.pluck(:id).uniq
    # Get all the implementations that are for snippets owned by the user and where they share the name of language being destroyed
    @implementations = Implementation.where(snippet_id: snippet_ids).where(language: @language.name)

    @implementations.each do |implementation|
      if implementation.destroy
        p "Successfully destroyed implementation"
      else
        p "Unsuccessfully destroyed implementation"
      end
    end

    if @language.destroy
      p "Successfully destroyed language"
    else
      p "Unsuccessfully destroyed language"
    end
    @languages = Language.accessible_by(current_ability)



    redirect_to languages_path
  end

  private
    def language_params
      params.require(:language).permit(:name, :logo)
    end
end
