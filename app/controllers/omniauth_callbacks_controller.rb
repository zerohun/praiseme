class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    sns_connection = SnsConnection.from_omniauth(request.env["omniauth.auth"])
    user = sns_connection.user
    if sns_connection.persisted? && user.present?
      if user.username != auth.info.nickname
        user.update_attribute :username, auth.info.nickname 
      end
      sign_in_and_redirect user, notice: "Signed in!"
    else
      session["devise.user_attributes"] = sns_connection.attributes
      session["sns_connection_id"] = sns_connection.id
      redirect_to new_user_registration_url
    end
  end
  alias_method :facebook, :all
end
