class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :quizzes, dependent: :destroy
  has_many :snippets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :languages, dependent: :destroy
end
