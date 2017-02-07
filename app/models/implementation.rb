class Implementation < ApplicationRecord
  belongs_to :snippet, inverse_of: :implementations
end
