class SnippetsController < ApplicationController

    def index
      @snippets = Snippet.all
    end

    def show
      @snippet = Snippet.find(params[:id])
    end

    def new
    end

    def create
      @snippet = Snippet.new(snippet_params)

      @snippet.save
      redirect_to @snippet
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
