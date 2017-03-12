class SnippetsController < ApplicationController
    before_filter :authenticate_user!

    def index
      @snippets = Snippet.accessible_by(current_ability)
    end

    def show
      @snippet = Snippet.find(params[:id])
      @category = Category.find_by_id(@snippet.category_id)
      @languages = Language.accessible_by(current_ability)
      # @languages = Language.limit(@allLanguages.length)
      # @implementations = Implementation.find(params[:id])
    end

    def new
      @snippet = Snippet.new
      @allLanguages = Language.accessible_by(current_ability)
      @languages = Language.accessible_by(current_ability)
      # @languages.length.times do
      #   language = @languages.build
      # end

      @languages.length.times do
        implementation = @snippet.implementations.build
      end
    end

    def create
      @snippet = Snippet.new(snippet_params)

      @snippet.user = current_user
      authorize! :create, @snippet

      # Include languages so that when errors redirect to new it won't error
      @languages = Language.accessible_by(current_ability)

      # @implementation = Implementation.new( params.require(:implementation).permit(:code, :language) )
      if @snippet.save

        #If admin we need to store data to be used later for default snippet look up
        if current_user.admin == true
          @snippet.default = true;
          # @snippet.default_id = true;
          # @snippet.update_attributes :default_id => @snippet.id
          @snippet.update_attributes(
            :default => true,
            :default_id => @snippet.id
            )
        end

        @snippets = Snippet.accessible_by(current_ability)
        redirect_to snippets_path
      else
        render("new")
      end
    end

    def edit
      @snippet = Snippet.find(params[:id])
      authorize! :edit, @snippet
      @languages = Language.accessible_by(current_ability)
    end

    def update
      @snippet = Snippet.find(params[:id])

      if @snippet.update(snippet_params)
        @snippets = Snippet.accessible_by(current_ability)
        authorize! :update, @snippet
        redirect_to snippets_path
      else
        render 'edit'
      end
    end

    def destroy
      @snippet = Snippet.find(params[:id])
      authorize! :destroy, @snippet
      @snippet.destroy
      @snippets = Snippet.accessible_by(current_ability)

      redirect_to snippets_path
    end

    def update_active
      @snippet = Snippet.find(params[:id])

      # if @snippet.update_attributes(:active => params[:active])
      if @snippet.update_attributes(:active => params[:active])
        # data = {:message => "Worked! " + params[:active]}
        # render :json => data, :status => :ok
      else
        # data = {:message => "Not worked! " + params[:active]}
        # render :json => data, :status => :ok
      end
    end


    def update_snippet
      snippet = Snippet.find(params[:id])
      # authorize! :update_snippet, snippet

      p "UPDATING SNIPPET"
      defaultSnippet = Snippet.find(snippet.default_id)

      p "CLONING SNIPPET: " + defaultSnippet.inspect
      cloned_snippet = defaultSnippet.deep_clone include: [:implementations]
      cloned_snippet.user = current_user
      cloned_snippet.default_id = defaultSnippet.id
      if cloned_snippet.save!
        p "Snippet updated successfully"
        snippet.destroy
      else
        p "Snippet failed to update"
      end
    end
    #
    # def add_snippet
    #   snippet = Snippet.find(params[:id])
    #   # authorize! :update_snippet, snippet
    #
    #   p "UPDATING SNIPPET"
    #   defaultSnippet = Snippet.find(snippet.default_id)
    #
    #   p "CLONING SNIPPET: " + defaultSnippet.inspect
    #   cloned_snippet = defaultSnippet.deep_clone include: [:implementations]
    #   cloned_snippet.user = current_user
    #   if cloned_snippet.save!
    #     p "Snippet updated successfully"
    #     snippet.destroy
    #   else
    #     p "Snippet failed to update"
    #   end
    # end

    private

      def save_snippet
        if @snippet.save
          @snippets = Snippet.accessible_by(current_ability)
          render :hide_form
        else
          render :show_form
        end
      end

      def snippet_params
        params.require(:snippet).permit(:title, :runtime_complexity, :space_complexity, :active, :category, :category_id, implementations_attributes:[:language, :code, :id, :snippet_id, :_destroy])
      end

end
