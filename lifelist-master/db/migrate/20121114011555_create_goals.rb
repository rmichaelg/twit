class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.text :description
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
