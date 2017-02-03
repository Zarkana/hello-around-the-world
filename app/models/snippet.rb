class Snippet < ApplicationRecord
  has_many :implementations

  accepts_nested_attributes_for :implementations
end
