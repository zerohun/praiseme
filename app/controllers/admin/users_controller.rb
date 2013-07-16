class Admin::UsersController < Admin::ApplicationController

  before_filter :is_admin_login

  def index
    @users = User.all
    if params[:q].present?
      @users = @users.where("users.username like '%#{params[:q]}%' or users.last_name like '%#{params[:q]}%' or users.first_name like '%#{params[:q]}%'")
    end
    @users = @users.page(params[:page]).per(20)  
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

 # def create
 #   @user = User.new(user_params)
 #   if @user.save
 #     redirect_to [:admin, @user], :notice => "Successfully created user."
 #   else
 #     render :new
 #   end
 # end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, :notice  => "Successfully updated user."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, :notice => "Successfully destroyed user."
  end
  private
  def user_params
    params.require(:user).permit(:username, :email, :is_blocked, :user_admin_type)
  end
end
