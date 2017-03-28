class Implementation < ApplicationRecord
  belongs_to :snippet, inverse_of: :implementations
  belongs_to :language

  validates :snippet, :language, presence: true
end
