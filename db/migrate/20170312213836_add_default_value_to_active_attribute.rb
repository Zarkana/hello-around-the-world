class AddDefaultValueToActiveAttribute < ActiveRecord::Migration[5.0]
  def change
    change_column :snippets, :active, :boolean, :default => false
  end
end
