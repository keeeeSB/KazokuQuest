class CreateFamilyInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :family_invitations do |t|
      t.references :family, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :family_invitations, :token, unique: true
  end
end
