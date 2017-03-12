class Users::RegistrationsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit]

  # GET /resource/sign_up
  def new
    p "STARTING"

    build_resource({})
    yield resource if block_given?
    p "RESPOND WITH RESOURCE 1"
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    p "RESOURCE SAVED"
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)

        # Copy data

        initialize_user(resource)

        #
        p "RESPOND WITH RESOURCE 1"
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        p "RESPOND WITH RESOURCE 2"
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      p "RESPOND WITH RESOURCE 3"
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
    p "INITIALIZING USER"
    if User.exists?(admin: true)
      admin = User.where('admin = ?', true).first
      adminSnippets = admin.snippets.where(category_id: nil)
      adminLanguages = admin.languages.where("languages.user" => admin)
      adminCategories = admin.categories.where("categories.user" => admin)
    end

    adminLanguages.each do |language|
      p "CLONING LANGUAGE: " + language.inspect
      cloned_language = language.deep_clone
      cloned_language.user = resource
      cloned_language.logo = language.logo
      if cloned_language.save!
        p "Language saved successfully"
      else
        p "Language failed to save"
      end
    end

    adminSnippets.each do |snippet|
      p "CLONING SNIPPET: " + snippet.inspect
      cloned_snippet = snippet.deep_clone include: [:implementations]
      cloned_snippet.user = resource
      cloned_snippet.default_id = snippet.id
      if cloned_snippet.save!
        p "Snippet saved successfully"
      else
        p "Snippet failed to save"
      end
    end

    adminCategories.each do |category|
      p "CLONING CATEGORY: " + category.inspect

      cloned_category = category.deep_clone  include: [
        snippets: [ :implementations, if: lambda {|snippet| snippet.user == admin } ]
      ]

      cloned_category.user = resource
      cloned_category.snippets.each do |snippet|
        snippet.user = resource
        # snippet.default_id = snippet.id
      end
      p cloned_category.inspect
      if cloned_category.save!
        p "Category saved successfully"
      else
        p "Category failed to save"
      end
    end
  end

end
