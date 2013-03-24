class UserProfilesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:show]
  def index
    @users = User
  end

  def show
    @user = User.find(params[:id])
    render :layout => "before_login" if current_user.blank?
  end
end
