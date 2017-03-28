class Language < ApplicationRecord
  belongs_to :user

  validates :name, :user, presence: true
  validates :name, length: { in: 1..20}, uniqueness: { scope: :user_id }

  has_many :implementations, inverse_of: :language, :dependent => :destroy

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :logo, presence: true,
    :content_type => { :content_type => /\Aimage/ },
    size: { in: 0..300.kilobytes }
end
