class Work < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :date_on, presence: true
  validates :memo, length: { maximum: 100 }
end
