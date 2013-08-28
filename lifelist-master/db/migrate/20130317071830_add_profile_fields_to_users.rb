class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :about, :text
    add_column :users, :location, :string
    add_column :users, :birthday, :date
  end
end
