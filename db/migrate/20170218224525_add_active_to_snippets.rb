class AddActiveToSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column :snippets, :active, :boolean
  end
end
