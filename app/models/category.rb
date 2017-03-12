class Category < ApplicationRecord
  belongs_to :user

  validates_presence_of :user

  has_many :snippets, :dependent => :restrict_with_error

  after_create :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end
end
