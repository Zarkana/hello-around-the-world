class Language < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates_presence_of :user

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
end
