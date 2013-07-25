class UsersController < Devise::RegistrationsController
  def new
    super
    resource.sns_connected = false if session[:sns_connection_id].present?
  end
  def create
    super
    if resource.errors.blank? && session[:sns_connection_id].present?
      id =  session[:sns_connection_id]
      SnsConnection.find(id).update_attribute :user_id, resource.id
    end
  end
  def edit
    super
  end

  def show
    super
  end

  def update
    current_user.update_attributes(user_params)
    redirect_to user_profile_path(current_user)
  end

  private
  def user_params
    params.require(:user).permit(:introduce)
  end
end
