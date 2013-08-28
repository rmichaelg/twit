class AddCategories < ActiveRecord::Migration
  def up
    categories = ["Adventure", "Athletics", "Causes", "Creative", "Experiences" , "Financial", "Health", "Learning", "Professional", "Relationships", "Self-improvement", "Spiritual", "Travel"]
    categories.each {|category| Category.new(:name=>category).save}
  end

  def down
    categories = ["Adventure", "Athletics", "Causes", "Creative", "Experiences" , "Financial", "Health", "Learning", "Professional", "Relationships", "Self-improvement", "Spiritual", "Travel"]
    categories.each {|category| Category.where(:name=>category).destroy_all}
  end
end
