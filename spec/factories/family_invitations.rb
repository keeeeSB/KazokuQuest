FactoryBot.define do
  factory :family_invitation do
    family
    sequence(:email) { "family_invite_#{_1}@example.com" }
    token { 'a * 32' }
    expires_at { Time.current + 1.day }
  end
end
