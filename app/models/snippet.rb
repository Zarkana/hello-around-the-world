class Snippet < ApplicationRecord
  has_many :implementations, inverse_of: :snippet, :dependent => :destroy
  belongs_to :category
  # :dependent => :destroy

  accepts_nested_attributes_for :implementations, allow_destroy: true
end
