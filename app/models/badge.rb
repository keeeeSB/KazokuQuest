class Badge < ApplicationRecord
  extend Enumerize

  enumerize :rule_type, in: %i[tasks_completed total_points streak_days first_task]

  has_many :user_badges, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :rule_type, presence: true
  validates :rule_value, presence: true

  scope :default_order, -> { order(:id) }
  scope :active, -> { where(enabled: true) }
end
