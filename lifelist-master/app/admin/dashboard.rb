ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do

          column do
            panel "Recent Users" do
              ul do
                User.order("created_at desc").limit(15).all.map do |user|
                  li link_to(user.email, admin_user_path(user))
                end
              end
            end
          end
    


          column do
            panel "Recent Goals" do
              ul do
                Goal.order("created_at desc").limit(25).all.map do |goal|
                  li link_to(goal.name, admin_goal_path(goal))
                end
              end
            end
          end

        end
  end # content
end
