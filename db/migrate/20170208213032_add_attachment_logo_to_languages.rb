class AddAttachmentLogoToLanguages < ActiveRecord::Migration
  def self.up
    change_table :languages do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :languages, :logo
  end
end
