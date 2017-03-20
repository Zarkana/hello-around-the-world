class RemoveNameFromImplementations < ActiveRecord::Migration[5.0]
  def change
    remove_column :implementations, :language
    remove_column :implementations, :active
  end
end
