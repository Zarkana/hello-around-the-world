class Category < ApplicationRecord
  has_many :snippets, :dependent => :restrict_with_error

  after_create :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end
end
