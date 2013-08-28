ActiveAdmin.register GoalImage do
  filter :user_id
  filter :category_id
  before_filter :set_pagination

  index do
    column "id"
    column "image" do |i|
      image_tag(i.image, :width=>"100")
    end
    column "keywords"
    column "user" do |u|
      u.user.username if u.user
    end
    column "created_at"
    default_actions
  end

  controller do
    private

    def set_pagination
      @per_page = 100
    end
  end
end
