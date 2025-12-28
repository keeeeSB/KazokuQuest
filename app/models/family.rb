class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :family_invitations, dependent: :destroy

  validates :name, presence: true
end
