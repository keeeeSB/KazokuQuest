class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.date :done_on, null: false
      t.text :memo

      t.timestamps
    end
  end
end
