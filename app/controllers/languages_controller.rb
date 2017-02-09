class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end

  def show
    # @language = Language.find(params[:id])
    redirect_to languages_path
  end

  def new
    @language = Language.new
  end

  def edit
    @language = Language.find(params[:id])
  end

  def create
    @language = Language.new(language_params)

    if @language.save
      # redirect_to @language
      redirect_to languages_path
    else
      render 'new'
    end
  end

  def update
    @language = Language.find(params[:id])

    if @language.update(language_params)
      # redirect_to @language
      redirect_to languages_path
    else
      render 'edit'
    end
  end

  def destroy
    @language = Language.find(params[:id])

    # destroy_logo

    @language.destroy

    redirect_to languages_path
  end
  #
  # def destroy_logo
  #   @language = Language.find(params[:id])
  #
  #   @language.logo = nil;
  #   @language.save
  # end

  private
    def language_params
      params.require(:language).permit(:name, :logo)
    end
end
