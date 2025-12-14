FactoryBot.define do
  factory :user do
    name { 'アリス' }
    sequence(:email) { "user_#{_1}@example.com" }
    password { 'password12345' }
    role { 'father' }
    confirmed_at { Time.current }
  end
end
