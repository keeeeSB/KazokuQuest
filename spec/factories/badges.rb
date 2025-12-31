FactoryBot.define do
  factory :badge do
    name { '初家事バッジ' }
    describe { '初めて家事を行ったユーザーに付与されるバッジです' }
    rule_type { 'works_count' }
    rule_value { 1 }
    enabled { true }
  end
end
