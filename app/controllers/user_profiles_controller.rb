class UserProfilesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:show]
  def index
   # @users = User
   @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @og_type = "profile"
    @og_title = @user.username
    @og_image = @user.image_url
    @og_url = "http://#{request.host}/user_profiles/#{@user.id}"
    @user_stamps = @user.user_stamps.order('user_stamps.score desc, user_stamps.created_at desc').page(params[:page]).per(6)
    # @personal_feed = Compliment.where("sender_id = ? or receiver_id = ?",@user.id,@user.id)
    @personal_feed = MyUserNewsFeed.where(:user_id => params[:id])
    @personal_feed = @personal_feed.order('created_at desc').page(params[:page]).per(5)
   
    @keyword = ([@user.username] + @user.user_stamps.joins(:stamp).pluck("stamps.title")).join(',')
    render :layout => "before_login" if current_user.blank?
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end

  def stamp_list
    @user_stamps = User.find(params[:id]).user_stamps.order('user_stamps.score desc,user_stamps.created_at desc').page(params[:page]).per(6)
    if params[:verb].present?
      @user_stamps = @user_stamps.joins(:stamp).where("stamps.verb = ?", params[:verb])
    end
    render :layout => false
  end


end
