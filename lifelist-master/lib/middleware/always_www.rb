class AlwaysWww
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.host.start_with?("www.")
      @app.call(env)
    elsif request.host.start_with?("beta.")
      [301, {"Location" => request.url.sub("//beta.", "//www.")}, self]
    else
      [301, {"Location" => request.url.sub("//", "//www.")}, self]
    end
  end

  def each(&block)
  end
end
