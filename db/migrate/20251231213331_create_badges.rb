class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :describe, null: false
      t.string :rule_type, null: false
      t.integer :rule_value, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :badges, :name, unique: true
    add_index :badges, %i[rule_type rule_value], unique: true
  end
end
