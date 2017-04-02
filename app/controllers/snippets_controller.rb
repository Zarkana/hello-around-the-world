class SnippetsController < ApplicationController
    before_filter :authenticate_user!
    include ApplicationHelper

    def index
      authorize! :index, Snippet
      # Snippets to list
      @snippets = Snippet.accessible_by(current_ability).order('created_at')
      # Snippets to display at bottom of sync list
      @unowned_snippets = get_unowned_snippets

      unowned_exists = @unowned_snippets.exists?
      updated_exists = !@snippets.find_by(:update_available => true).blank?
      modified_exists = !@snippets.where(:modified => true).find_by(:default => true).blank?

      # color of FAB button
      @color = "grey"
      if (updated_exists || unowned_exists) && !current_user.admin
        @color = "green"
      elsif modified_exists  && !current_user.admin
        @color = "blue"
      end
    end

    def show
      @snippet = Snippet.accessible_by(current_ability).find(params[:id])
      @category = Category.accessible_by(current_ability).find_by_id(@snippet.category_id)
      @implementations = @snippet.implementations
      authorize! :new, @snippet
    end

    def new
      @snippet = Snippet.new
      authorize! :new, @snippet

      build_implementations
    end

    def create
      @snippet = Snippet.new(snippet_params)
      @snippet.user = current_user
      @snippet.default = false
      authorize! :create, @snippet

      if @snippet.save
        #If admin we need to store data to be used later for default snippet look up
        if current_user.admin == true
          # @snippet.default = true;
          @snippet.update_attributes(
            :default => true,
            :default_id => @snippet.id
            )
        end

        redirect_to snippets_path
      else
        build_implementations
        @errors = @snippet.errors
        render 'new'
      end
    end

    def edit
      @snippet = Snippet.accessible_by(current_ability).find(params[:id])
      authorize! :edit, @snippet
      @implementations = @snippet.implementations
      add_new_implementations
    end

    def update
      @snippet = Snippet.find(params[:id])
      authorize! :update, @snippet

      #If admin we need to store data to be used later for default snippet look up
      if current_user.admin == true
        # Get all snippets that should be marked available for update, that are default and not owned by admin
        to_update_snippets = Snippet.where(default: true).where(default_id: @snippet.id).where.not(user: current_user).update_all(update_available: true)
      else
        # If current user is not admin then set snippet to modified, admins don't need modified to be set because they are the admin and they own the definitive version of the snippet
        @snippet.modified = true
      end

      if @snippet.update(snippet_params)
        redirect_to snippets_path
      else
        @errors = @snippet.errors
        render 'edit'
      end
    end

    def destroy
      @snippet = Snippet.find(params[:id])
      authorize! :destroy, @snippet
      @snippet.destroy

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

    #TODO: Should be moved to private

    def update_snippet
      snippet = Snippet.find(params[:id])
      default_snippet = Snippet.find(snippet.default_id)
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

      cloned_snippet.implementations.each do |implementation|
        # Get the id of the language owned by the current user that has a default_id equivalent to the implementations language id
      implementation.language_id = Language.where(user_id: current_user.id).where(default_id: implementation.language_id).first.id
    end
    # delete before or else validation will fail for duplicate titles
    p "destroy"
    snippet.destroy
    if cloned_snippet.save!
      p "Snippet updated successfully"
      @updated_snippet = cloned_snippet
      render :json => @updated_snippet
    else
      p "Snippet failed to update"
    end
  end

  def add_snippet
    default_snippet = Snippet.find(params[:id])
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

    cloned_snippet.implementations.each do |implementation|
      # Get the id of the language owned by the current user that has a default_id equivalent to the implementations language id
      implementation.language_id = Language.where(user_id: current_user.id).where(default_id: implementation.language_id).first.id
    end

    if cloned_snippet.save!
      p "Snippet added successfully"
      @added_snippet = cloned_snippet
      render :json => @added_snippet
    else
      p "Snippet failed to be added"
    end
  end

  private
    def build_implementations
      languages = Language.accessible_by(current_ability)

      @implementations = []
      # Create blank implementations to be used in new view
      languages.each do |language|
        implementation = @snippet.implementations.build
        implementation.language_id = language.id
        @implementations << implementation
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

    # Gets all of the snippets that are owned by the admin but not owned by the user
    def get_unowned_snippets
      admin = User.find_by admin: true
      admin_snippets = Snippet.where(:default => true).where(:user => admin)
      users_default_snippets = Snippet.accessible_by(current_ability).where(:default => true)

      unowned_snippets = admin_snippets
      user_snippets = users_default_snippets.pluck(:default_id).uniq
      if !user_snippets.empty?
        unowned_snippets = unowned_snippets.where('id NOT IN (?)', user_snippets)
      else
        unowned_snippets = admin_snippets
      end
      unowned_snippets.each do |unowned_snippet|
        p unowned_snippet.inspect
      end
      unowned_snippets
    end

    def add_new_implementations
      languages = Language.accessible_by(current_ability)
      implemented_languages = @implementations.pluck(:language_id).uniq

      languages.each do |language|
        if !implemented_languages.include? language.id
          implementation = Implementation.new()
          implementation.language_id = language.id
          # TODO: Get actual code from admin
          implementation.code = ""
          implementation.snippet_id = @snippet.id
          if implementation.save
            p "Implementation added successfully"
          else
            p "Implementation added unsuccessfully"
          end
        end
      end
    end

    def snippet_params
      # params.require(:snippet).permit(:title, :runtime_complexity, :space_complexity, :category_id, implementations_attributes:[:language_id, :code])
      params.require(:snippet).permit(:title, :runtime_complexity, :space_complexity, :active, :category, :category_id, implementations_attributes:[:language_id, :code, :id, :snippet_id, :_destroy])
    end

end
