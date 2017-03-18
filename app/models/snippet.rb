class Snippet < ApplicationRecord
  belongs_to :user

  validates_presence_of :user

  has_many :implementations, inverse_of: :snippet, :dependent => :destroy
  has_many :quiz_snippets
  # belongs_to :category
  # removed the above to allow for not requiring category

  # :dependent => :destroy

  accepts_nested_attributes_for :implementations, allow_destroy: true

  after_create :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end

end
