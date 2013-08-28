class UpdateSignUpTokenFields < ActiveRecord::Migration
  def change
    remove_column :sign_up_tokens, :active
    add_column :sign_up_tokens, :sent, :boolean
  end
end
