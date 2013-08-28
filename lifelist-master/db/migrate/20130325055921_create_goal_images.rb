class CreateGoalImages < ActiveRecord::Migration
  def change
    add_column  :goals, :goal_image_id, :integer
    remove_column :goals, :image
    
    create_table :goal_images do |t|
      t.integer :category_id
      t.integer :user_id
      t.string :keywords
      t.string   :image
      t.timestamps
    end
  end
end
