class KoalaCallbacksController < ApplicationController
  def compliment
    state = JSON.parse(params[:state])
    compliment = Compliment.find(state["compliment_id"])
    og_params_hash = state["og_params_hash"]
    compliment.post_og(og_params_hash)
    redirect_to url_for(compliment)
  end
end
