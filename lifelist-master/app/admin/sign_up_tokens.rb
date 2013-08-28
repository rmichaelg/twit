ActiveAdmin.register SignUpToken do
  filter :user_id
  filter :name
  index do
    column "id"
    column "url" do |u|
      link_to u.url, u.url if u.url
    end
    column "registered_as" do |u|
      u.user.email if u.user
    end
    column "active?"
    column "sent"
    column "created_at"
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :sent
    end
    f.actions
  end
end
