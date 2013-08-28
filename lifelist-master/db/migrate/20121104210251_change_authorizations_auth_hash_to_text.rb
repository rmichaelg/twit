class ChangeAuthorizationsAuthHashToText < ActiveRecord::Migration
  def up
      change_column :authorizations, :auth_hash, :text
  end
  def down
      change_column :authorizations, :auth_hash, :string
  end
end
