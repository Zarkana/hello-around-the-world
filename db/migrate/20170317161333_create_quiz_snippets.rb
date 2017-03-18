class CreateQuizSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :quiz_snippets do |t|
      t.text :attempt
      t.text :answer
      t.string :title
      t.integer :quiz_id

      t.timestamps
    end
  end
end
