class Removenameandlanguage < ActiveRecord::Migration[5.0]
  def change
    remove_column :snippets, :language
    remove_column :snippets, :code
  end
end
