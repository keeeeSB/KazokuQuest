class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :rule_type, null: false
      t.integer :rule_value, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :badges, :name, unique: true
  end
end
