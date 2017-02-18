class Category < ApplicationRecord
  has_many :snippets, :dependent => :restrict_with_error

end
