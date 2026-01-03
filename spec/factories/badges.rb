FactoryBot.define do
  factory :badge do
    name { '初家事バッジ' }
    description { '初めて家事を行ったユーザーに付与されるバッジ。' }
    rule_type { 'works_count' }
    rule_value { 1 }
    enabled { true }
  end
end
