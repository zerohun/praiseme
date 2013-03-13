class UserProfilesController < ApplicationController
  def index
    @users = User
  end

  def show
    @user = User.find(params[:id])
  end
end
