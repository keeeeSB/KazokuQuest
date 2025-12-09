class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enumerize :role, in: %i[father mother grandpa grandma]

  validates :name, presence: true
  validates :role, presence: true
end
