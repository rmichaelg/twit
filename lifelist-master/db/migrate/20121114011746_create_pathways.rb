class CreatePathways < ActiveRecord::Migration
  def change
    create_table :pathways do |t|
      t.string :name
      t.text :description
      t.integer :goal_id
      t.integer :user_id

      t.timestamps
    end
  end
end
