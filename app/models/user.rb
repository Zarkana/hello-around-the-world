class User < ApplicationRecord

  validates :email, :password, presence: true
  validates :email, length: { in: 4..40}, uniqueness: true
  validates :password, length: { minimum: 5}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :quizzes, dependent: :destroy
  has_many :snippets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :languages, dependent: :destroy
  has_one :user_detail, dependent: :destroy
end
