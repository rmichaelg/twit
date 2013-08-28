class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :token
      t.string :uid
      t.string :auth_hash
      t.integer :user_id

      t.timestamps
    end
  end
end
