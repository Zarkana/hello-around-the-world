class AddSnippetToImplementations < ActiveRecord::Migration[5.0]
  def change
    add_reference :implementations, :snippet, foreign_key: true
  end
end
