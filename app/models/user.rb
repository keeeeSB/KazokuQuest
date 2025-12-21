class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :family, optional: true
  has_many :works, dependent: :destroy

  enumerize :role, in: %i[father mother grandpa grandma]

  validates :name, presence: true
  validates :role, presence: true
end
