# This is to make ActiveAdmin work with will_paginate
# https://github.com/gregbell/active_admin/wiki/How-to-work-with-will_paginate
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end