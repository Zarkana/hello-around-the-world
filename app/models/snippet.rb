class Snippet < ApplicationRecord
  has_many :implementations, inverse_of: :snippet, :dependent => :destroy
  # :dependent => :destroy

  accepts_nested_attributes_for :implementations, reject_if: proc { |attributes| attributes[:code].blank? }, allow_destroy: true
end
