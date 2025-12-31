class Badge < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :rule_type, presence: true, uniqueness: { scope: :rule_value }
  validates :rule_value, presence: true

  scope :default_order, -> { order(:id) }
end
