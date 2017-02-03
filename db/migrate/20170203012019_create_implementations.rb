class CreateImplementations < ActiveRecord::Migration[5.0]
  def change
    create_table :implementations do |t|
      t.string :language
      t.text :code
      t.references :snippet, foreign_key: true

      t.timestamps
    end
  end
end
