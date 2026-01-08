FactoryBot.define do
  factory :badge do
    name { '初家事バッジ' }
    description { '初めて家事を行ったユーザーに付与されるバッジ。' }
    rule_type { 'task_count' }
    rule_value { 1 }
    enabled { true }
  end
end
