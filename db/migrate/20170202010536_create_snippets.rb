class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :code
      t.string :language
      t.string :runtime_complexity
      t.string :space_complexity

      t.timestamps
    end
  end
end
