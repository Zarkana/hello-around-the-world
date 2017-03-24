module ApplicationHelper
  def get_implementation(language)

  end

  def get_language(implementation, snippet_id)
    language = Language.accessible_by(current_ability).find_by_id(implementation.language_id)
  end
end
