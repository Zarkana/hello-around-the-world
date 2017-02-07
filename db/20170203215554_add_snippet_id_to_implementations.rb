class AddSnippetIdToImplementations < ActiveRecord::Migration[5.0]
  def change
    add_column :implementations, :snippet_id, :integer
  end
end
