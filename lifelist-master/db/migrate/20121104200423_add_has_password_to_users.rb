class AddHasPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_password, :boolean, default: true
  end
end
