class FamilyInvitation < ApplicationRecord
  belongs_to :family

  before_validation :set_token, :set_expires_at

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  private

  def set_token
    self.token ||= generate_token
  end

  def set_expires_at
    self.expires_at ||= 1.day.from_now
  end

  def generate_token
    loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless self.class.exists?(token:)
    end
  end
end
