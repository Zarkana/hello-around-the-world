class SnippetsController < ApplicationController

    def index
      # @snippets = Snippet.all
    end

    def show
    end

    def new
    end

    def create
      render plain: params[:snippet].inspect
    end

end
