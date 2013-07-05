class StampSuggestions
  def initialize(app)
    @app = app
  end

  def call(env)
    if env ["PATH_INFO"] = "search_suggestions"
      request = Rack::Request.new(env)
      terms = StampSuggestion.name_for(request.params["term"])
      [200,{"Content-Type" => "application/json"}, [terms.to_json]]
    else
      @app.call(env)
    end
  end
end
