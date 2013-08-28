module ApplicationHelper
  def is_active? controller_name, action_name
    'active' if params[:controller] == controller_name.to_s && params[:action] == action_name.to_s
  end

  def pageless(total_pages, url=nil, results_container='results', container=nil)
    opts = {
      totalPages:   total_pages,
      url:          url,
      loader:  '#pageless-loader'
    }

    container && opts[:container] ||= container
    # output = render partial: 'explore'
    javascript_tag("$('##{results_container}').pageless(#{opts.to_json});")
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
