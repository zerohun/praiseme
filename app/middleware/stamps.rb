class Stamps
  def initialize(app)
    @app = app
  end

  def call(env)
    if env ["PATH_INFO"] = "search_suggestions"
      [200,{"Content-Type" => "application/json"}, [terms.to_json]]
    else
      @app.call(env)
    end
  end
end
