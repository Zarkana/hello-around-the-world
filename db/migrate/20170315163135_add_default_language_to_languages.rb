class AddDefaultLanguageToLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :languages, :default_id, :integer
    add_column :languages, :default, :boolean, default: false
  end
end
