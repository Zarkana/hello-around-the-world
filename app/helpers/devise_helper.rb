module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:p, msg, class: ["alert", "alert-danger"]) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <!-- Modal Structure -->
    <div class="modal error-modal">
      <div class="modal-header">
        <h3 class="section-header white-text">Hey, guess what?</h3>
      </div>
      <div class="modal-content">
        <b>
          #{sentence}
        </b>
        #{messages}
      </div>
      <div class="modal-footer">
        <a href="#!" class=" modal-action modal-close waves-effect btn-flat">Got It!</a>
      </div>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
