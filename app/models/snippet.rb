class Snippet < ApplicationRecord
  belongs_to :user

  validates :title, :user, presence: true
  validates :title, length: { in: 1..50 }, uniqueness: { scope: :user_id }
  validates :runtime_complexity, length: { maximum: 30 }
  validates :space_complexity, length: { maximum: 30 }

  has_many :implementations, inverse_of: :snippet, :dependent => :destroy
  has_many :quiz_snippets

  accepts_nested_attributes_for :implementations, allow_destroy: true

  after_create :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end

end
