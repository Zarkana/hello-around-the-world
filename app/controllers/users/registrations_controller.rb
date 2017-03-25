class Users::RegistrationsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit]

  # GET /resource/sign_up
  def new
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)

        # Copy data
        initialize_user(resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  def translation_scope
    'devise.registrations'
  end

  def initialize_user(resource)
    if User.exists?(admin: true)
      admin = User.where('admin = ?', true).first
      # admin_snippets = admin.snippets.where(category_id: nil)
      admin_snippets = admin.snippets
      admin_languages = admin.languages.where("languages.user" => admin)
      admin_categories = admin.categories.where("categories.user" => admin)
    else
      # There needs to be one
      return
    end

    admin_languages.each do |language|
      cloned_language = language.deep_clone
      cloned_language.user = resource
      cloned_language.logo = language.logo
      cloned_language.default_id = language.id
      if cloned_language.save!
        p "Language saved successfully"
      else
        p "Language failed to save"
      end
    end

    admin_snippets.each do |snippet|
      cloned_snippet = snippet.deep_clone include: [:implementations]
      cloned_snippet.user = resource
      cloned_snippet.default_id = snippet.id

      # Unless there is no category assigned
      unless snippet.category_id == nil
        # Unless their already exists a record with the category_id we are going to add
        unless current_user.categories.where(default_id: snippet.category_id).exists?
          # clone the snippet with category_id
          cloned_snippet.category_id = add_category(snippet.category_id)
        else
          # make it the same id as the original snippet to avoid duplication
          cloned_snippet.category_id = current_user.categories.where(default_id: snippet.category_id).first.id
          # cloned_snippet.category_id = current_user.categories.find(:id, :conditions => [ "user_name = ?", user_name])
        end
      end

      cloned_snippet.implementations.each do |implementation|
        # Get the id of the language owned by the current user that has a default_id equivalent to the implementations language id
        # This should properly update it to behave correctly
        implementation.language_id = Language.where(user_id: resource.id).where(default_id: implementation.language_id).first.id
      end

      # TODO:Make sure that the snippets category_id is correct
      if cloned_snippet.save!
        p "Snippet saved successfully"
      else
        p "Snippet failed to save"
      end
    end
  end


  def add_category(id)
    category = Category.find(id)
    cloned_category = category.deep_clone
    cloned_category.user = current_user
    # Make sure we aren't making the category twice
    if cloned_category.save!
      p "Category saved successfully"
      cloned_category.id
    else
      p "Category failed to save"
    end
  end
end
