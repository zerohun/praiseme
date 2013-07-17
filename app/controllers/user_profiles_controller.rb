class UserProfilesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:show]
  def index
    @users = User
  end

  def show
    @user = User.find(params[:id])
    @og_type = "profile"
    @og_title = @user.username
    @og_image = @user.image_url
    @og_url = "http://#{request.host}/user_profiles/#{@user.id}"
    
    @personal_feed = Compliment.where("sender_id = ? or receiver_id = ?",@user.id,@user.id)
    @personal_feed = @personal_feed.order('created_at desc').page(params[:page]).per(2)
    
    render :layout => "before_login" if current_user.blank?
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end
end
