class UsersController < Devise::RegistrationsController
  def new
    super
    
    
  end
  def create
    super
    if resource.errors.blank? && session[:sns_connection_id].present?
      id =  session[:sns_connection_id]
      SnsConnection.find(id).update_attribute :user_id, resource.id
    end
  end
end
