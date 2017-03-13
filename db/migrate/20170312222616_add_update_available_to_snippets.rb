class AddUpdateAvailableToSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column :snippets, :update_available, :boolean, default: false
  end
end
