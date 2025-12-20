class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.integer :point, null: false

      t.timestamps
    end
  end
end
