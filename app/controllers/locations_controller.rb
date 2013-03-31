class LocationsController < ApplicationController
  def update
    if current_user.present?
      current_user.update_attributes :latitude => params[:latitude], :longitude => params[:longitude]
      render :json => {:result => "success"}
    else
      render :json => {:result => "you have to login first"}
    end
  end
end
