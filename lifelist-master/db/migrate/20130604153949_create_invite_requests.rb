class CreateInviteRequests < ActiveRecord::Migration
  def change
    create_table :invite_requests do |t|
      t.string :username
      t.string :email

      t.timestamps
    end
    add_column :sign_up_tokens, :invite_request_id, :integer
  end
end
