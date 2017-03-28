class Category < ApplicationRecord
  belongs_to :user

  validates :name, :user, presence: true
  validates :name, length: { in: 1..50}, uniqueness: { scope: :user_id }

  has_many :snippets, :dependent => :restrict_with_error

  after_create :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end
end
