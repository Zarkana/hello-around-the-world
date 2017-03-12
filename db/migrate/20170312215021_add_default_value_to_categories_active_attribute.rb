class AddDefaultValueToCategoriesActiveAttribute < ActiveRecord::Migration[5.0]
  def change
    change_column :categories, :active, :boolean, :default => false
  end
end
