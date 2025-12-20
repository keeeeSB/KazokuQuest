class Task < ApplicationRecord
  extend Enumerize

  enumerize :category, in: %i[housework childcare]

  validates :name, presence: true
  validates :category, presence: true
  validates :point, presence: true

  scope :default_order, -> { order(id: :asc) }
end
