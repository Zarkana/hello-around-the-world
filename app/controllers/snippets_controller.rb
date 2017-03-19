class SnippetsController < ApplicationController
    before_filter :authenticate_user!

    def index
      # Organize the snippets alphabetically
      @snippets = Snippet.accessible_by(current_ability).order('LOWER(title)')

      admin = User.where('admin = ?', true).first
      # Get the snippets that should be added
      @default_admin_snippets = Snippet.where(:default => true).where(:user_id => admin.id)
      default_user_snippets = Snippet.where(:default => true).where(:user_id => current_user.id)

      @to_add_snippets = @default_admin_snippets

      user_snippets = default_user_snippets.pluck(:default_id).uniq
      if !user_snippets.empty?
        @to_add_snippets = @to_add_snippets.where('id NOT IN (?)', user_snippets)
      else
        @to_add_snippets = @default_admin_snippets
      end

      @add_snippets_exists = @to_add_snippets.exists?
      @updated_snippets_exists = Snippet.where(:update_available => true).exists?
      @modified_snippets_exists = Snippet.where(:modified => true).exists?
    end

    def show
      @snippet = Snippet.find(params[:id])
      @category = Category.find_by_id(@snippet.category_id)
      @languages = Language.accessible_by(current_ability)
    end

    def new
      @snippet = Snippet.new
      @allLanguages = Language.accessible_by(current_ability)
      @languages = Language.accessible_by(current_ability)

      # Create the blank implementations to be available on new view
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

      @implementations = @snippet.implementations

      @languages.each do |language|
        p language.inspect
      end
      @implementations.each do |implementation|
        p implementation.inspect
      end

      implementations = @implementations.pluck(:language).uniq
      languages = @languages.pluck(:name).uniq

      # Used to add languages that are new since original creation
      if implementations.size < languages.size
        p "Not enough implementations"
        to_add = languages.size - implementations.size

        for i in 0..(to_add-1)
          @new_implementation = Implementation.new()
          # Set the language equal to the implementation at the size of the original array + i
          @new_implementation.language = languages[(implementations.size) + i]
          @new_implementation.code = ""
          @new_implementation.snippet_id = @snippet.id
          @new_implementation.active = true
          if @new_implementation.save
            p "Implementation added successfully"
          else
            p "Implementation added unsuccessfully"
          end
        end
        @snippet = Snippet.find(params[:id])
      else
        p "Enough implementations"
      end
    end

    def add_implementation

    end

    def update
      @snippet = Snippet.find(params[:id])
      #If admin we need to store data to be used later for default snippet look up

      if current_user.admin == true
          # Get all snippets that should be marked available for update, that are default and not owned by admin
          to_update_snippets = Snippet.where(default: true).where(default_id: @snippet.id).where.not(user_id: current_user.id)
          # to_update_snippets do |snippet|
          #   snippet.update_attributes(:update_available, true)
          # end
          to_update_snippets.update_all(update_available: true)
      else
        # If current user is not admin then set snippet to modified
        # admins don't need modified to be set because they are the admin and they have the definitive version of the snippet
        @snippet.modified = true
      end

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
      default_snippet = Snippet.find(snippet.default_id)

      p "CLONING SNIPPET: " + default_snippet.inspect
      cloned_snippet = default_snippet.deep_clone include: [:implementations]
      cloned_snippet.user = current_user
      cloned_snippet.default_id = default_snippet.id

      # Unless there is no category assigned
      unless default_snippet.category_id == nil
        # Unless their already exists a record with the category_id we are going to add
        unless current_user.categories.where(default_id: default_snippet.category_id).exists?
          # clone the snippet with category_id
          cloned_snippet.category_id = add_category(default_snippet.category_id)
        else
          # make it the same id as the original snippet to avoid duplication
          cloned_snippet.category_id = current_user.categories.where(default_id: default_snippet.category_id).first.id
          # cloned_snippet.category_id = current_user.categories.find(:id, :conditions => [ "user_name = ?", user_name])
        end
      end

      # cloned_snippet.category_id = add_category(default_snippet.category_id)
      add_languages
      if cloned_snippet.save!
        p "Snippet updated successfully"
        snippet.destroy
        @updated_snippet = cloned_snippet
        render :json => @updated_snippet
      else
        p "Snippet failed to update"
      end
    end

    def add_snippet
      default_snippet = Snippet.find(params[:id])

      p "CLONING SNIPPET: " + default_snippet.inspect
      cloned_snippet = default_snippet.deep_clone include: [:implementations]
      cloned_snippet.user = current_user
      cloned_snippet.default_id = default_snippet.id

      # Unless there is no category assigned
      unless default_snippet.category_id == nil
        # Unless their already exists a record with the category_id we are going to add
        unless current_user.categories.where(default_id: default_snippet.category_id).exists?
          # clone the snippet with category_id
          cloned_snippet.category_id = add_category(default_snippet.category_id)
        else
          # make it the same id as the original snippet to avoid duplication
          cloned_snippet.category_id = current_user.categories.where(default_id: default_snippet.category_id).first.id
          # cloned_snippet.category_id = current_user.categories.find(:id, :conditions => [ "user_name = ?", user_name])
        end
      end

      # cloned_snippet.category_id = add_category(default_snippet.category_id)
      add_languages
      if cloned_snippet.save!
        p "Snippet added successfully"
        @added_snippet = cloned_snippet
        render :json => @added_snippet
      else
        p "Snippet failed to be added"
      end
    end

    def add_category(id)
      category = Category.find(id)
      cloned_category = category.deep_clone
      cloned_category.user = current_user
      if cloned_category.save!
        p "Category saved successfully"
        cloned_category.id
      else
        p "Category failed to save"
      end
    end

    def add_languages
      admin = User.where('admin = ?', true).first

      default_admin_languages = admin.languages.where(:default => true);
      default_user_languages = current_user.languages.where(:default => true);

      to_add_languages = default_admin_languages
      user_languages = default_user_languages.pluck(:default_id).uniq

      if !user_languages.empty?
        to_add_languages = to_add_languages.where('id NOT IN (?)', user_languages)
      else
        to_add_languages = default_admin_languages
      end

      to_add_languages.each do |language|
        cloned_language = language.deep_clone
        cloned_language.user = current_user
        cloned_language.logo = language.logo
        if cloned_language.save!
          p "Language saved successfully"
        else
          p "Language failed to save"
        end
      end
    end

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
