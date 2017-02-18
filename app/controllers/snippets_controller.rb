class SnippetsController < ApplicationController

    def index
      @snippets = Snippet.all
    end

    def show
      @snippet = Snippet.find(params[:id])
      @category = Category.find_by_id(@snippet.category_id)
      @allLanguages = Language.all
      @languages = Language.limit(@allLanguages.length)
      # @implementations = Implementation.find(params[:id])
    end

    def new
      @snippet = Snippet.new
      @allLanguages = Language.all
      @languages = Language.limit(@allLanguages.length)
      # @languages.length.times do
      #   language = @languages.build
      # end

      @languages.length.times do
        implementation = @snippet.implementations.build
      end
    end

    def edit
      @snippet = Snippet.find(params[:id])
      @allLanguages = Language.all
      @languages = Language.limit(@allLanguages.length)
    end

    def create
      @snippet = Snippet.new(snippet_params)
      # Include languages so that when errors redirect to new it won't error
      @allLanguages = Language.all
      @languages = Language.limit(@allLanguages.length)

      # @implementation = Implementation.new( params.require(:implementation).permit(:code, :language) )
      if @snippet.save
        #render plain: params[:snippet].inspect

        redirect_to snippets_path
        # render :inline => "Succcess"
      else
        render("new")
      end
      # @implementation.save
      # redirect_to @snippet
    end

    def update
      @snippet = Snippet.find(params[:id])

      if @snippet.update(snippet_params)
        redirect_to @snippet, notice: 'Successfully updated code'
      else
        render 'edit'
      end
    end

    def destroy
      @snippet = Snippet.find(params[:id])
      @snippet.destroy

      redirect_to snippets_path
    end

    private
      def snippet_params
        params.require(:snippet).permit(:title, :runtime_complexity, :space_complexity, :category, :category_id, implementations_attributes:[:language, :code, :id, :snippet_id, :_destroy])
      end

end
