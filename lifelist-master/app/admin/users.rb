ActiveAdmin.register User do
  before_filter :set_pagination

  controller do
    private

    def set_pagination
      @per_page = 100
    end
  end
end
