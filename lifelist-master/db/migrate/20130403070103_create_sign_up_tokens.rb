class CreateSignUpTokens < ActiveRecord::Migration
  def change
    create_table :sign_up_tokens do |t|
      t.string :token
      t.boolean :active, null: false, default: true
      t.integer :user_id

      t.timestamps
    end
  end
end
