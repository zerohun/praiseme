class StampSuggestionsController < ApplicationController
  def index
    render json: StampSuggestion.name_for(params[:term])
  end

end
