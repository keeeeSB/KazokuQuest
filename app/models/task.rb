class Task < ApplicationRecord
  extend Enumerize

  enumerize :category, in: %i[housework childcare]

  has_many :works, dependent: :destroy

  validates :name, presence: true
  validates :category, presence: true
  validates :point, presence: true

  scope :default_order, -> { order(id: :asc) }
end
