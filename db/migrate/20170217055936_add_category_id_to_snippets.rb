class AddCategoryIdToSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column :snippets, :category_id, :integer
    add_index  :snippets, :category_id
  end
end
