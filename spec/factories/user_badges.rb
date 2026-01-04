FactoryBot.define do
  factory :user_badge do
    user
    badge
    awarded_at { Time.current }
  end
end
