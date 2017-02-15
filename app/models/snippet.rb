class Snippet < ApplicationRecord
  has_many :implementations, inverse_of: :snippet, :dependent => :destroy
  # :dependent => :destroy

  accepts_nested_attributes_for :implementations, allow_destroy: true
end
