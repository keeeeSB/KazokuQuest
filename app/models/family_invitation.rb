class FamilyInvitation < ApplicationRecord
  belongs_to :family

  validates :email, presence: true
  validates :token, presence: true
  validates :expires_at, presence: true
end
