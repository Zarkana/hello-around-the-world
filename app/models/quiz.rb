class Quiz < ApplicationRecord
  belongs_to :user

  validates_presence_of :user

  has_many :quiz_snippets, inverse_of: :quiz, :dependent => :destroy

  accepts_nested_attributes_for :quiz_snippets, allow_destroy: true
end
