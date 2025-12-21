FactoryBot.define do
  factory :work do
    user
    task
    done_on { Date.current }
    memo { '頑固な汚れでした。' }
  end
end
