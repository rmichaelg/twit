class AddReceiveEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_email, :boolean
  end
end
