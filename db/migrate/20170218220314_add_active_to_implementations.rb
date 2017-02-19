class AddActiveToImplementations < ActiveRecord::Migration[5.0]
  def change
    add_column :implementations, :active, :boolean
  end
end
