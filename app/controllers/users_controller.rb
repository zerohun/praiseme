class UsersController < Devise::RegistrationsController
  layout false
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
end
