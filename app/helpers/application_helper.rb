module ApplicationHelper
  def get_customization_status(snippet)
    status = "Default"
    if snippet.default
      if snippet.update_available
        status = "Update Available"
      elsif snippet.modified
        status = "Modified"
      end
    else
      status = "Modified"
    end
    status
  end

  def get_snippet_category(snippet)
    category = Category.find_by_id(snippet.category_id)
    category_name = ""

    if !category.blank?
      category_name = category.name
    end
    category_name
  end

  def get_implementation_count(snippet)
    snippet.implementations.where.not(:code => "").count
  end

  def get_language(implementation, snippet_id)
    language = Language.accessible_by(current_ability).find_by_id(implementation.language_id)
  end
end
