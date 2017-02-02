class SnippetsController < ApplicationController

    def index
      @snippets = Snippet.all
    end

    def show
      @snippet = Snippet.find(params[:id])
    end

    def new
      @snippet = Snippet.new
    end

    def edit
      @snippet = Snippet.find(params[:id])
    end

    def create
      @snippet = Snippet.new(snippet_params)

      @snippet.save
      redirect_to @snippet
    end

    def update
      @snippet = Snippet.find(params[:id])

      if @snippet.update(snippet_params)
        redirect_to @snippet
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
        params.require(:snippet).permit(:title, :code, :language, :runtime_complexity, :space_complexity)
      end

end
