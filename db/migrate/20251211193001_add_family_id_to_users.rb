class AddFamilyIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :family, foreign_key: true
  end
end
