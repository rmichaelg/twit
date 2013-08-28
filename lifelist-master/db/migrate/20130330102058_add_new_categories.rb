class AddNewCategories < ActiveRecord::Migration
  def up
    categories_new = ["Habits", "Altruism", "Personal Development"]
    categories_new.each {|category| Category.new(:name=>category).save}

    categories_old = ["Causes", "Self-improvement"]
    categories_old.each {|category| Category.where(:name=>category).destroy_all}
  end

  def down
    categories_old = ["Habits", "Altruism", "Personal Development"]
    categories_old.each {|category| Category.where(:name=>category).destroy_all}

    categories_new = ["Causes", "Self-improvement"]
    categories_new.each {|category| Category.new(:name=>category).save}
  end
end
