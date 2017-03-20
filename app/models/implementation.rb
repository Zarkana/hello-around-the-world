class Implementation < ApplicationRecord
  belongs_to :snippet, inverse_of: :implementations
  belongs_to :language
end
