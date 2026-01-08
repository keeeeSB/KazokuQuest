class AddRuleCategoryToBadge < ActiveRecord::Migration[8.0]
  def change
    add_column :badges, :rule_category, :string
  end
end
