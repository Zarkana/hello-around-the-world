class Implementation < ApplicationRecord
  belongs_to :snippet, inverse_of: :implementations, dependent: :destroy

  after_initialize :init

  def init
    self.active  ||= true   #will set the default value only if it's nil
  end
end
