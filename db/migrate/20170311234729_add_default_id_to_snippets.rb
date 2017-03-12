class AddDefaultIdToSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column :snippets, :default_id, :integer
    add_column :snippets, :default, :boolean, default: false
    add_column :snippets, :modified, :boolean, default: false
    add_column :snippets, :visible, :boolean, default: false
    add_column :languages, :visible, :boolean, default: false
  end
end
