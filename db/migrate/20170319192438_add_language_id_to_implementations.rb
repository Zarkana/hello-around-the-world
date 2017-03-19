class AddLanguageIdToImplementations < ActiveRecord::Migration[5.0]
  def change
    add_column :implementations, :language_id, :integer
  end
end
