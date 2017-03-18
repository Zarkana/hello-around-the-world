class AddSnippetIdToQuizSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_snippets, :snippet_id, :integer
  end
end
