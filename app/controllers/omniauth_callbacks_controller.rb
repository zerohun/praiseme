class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    cookies['need_to_check_location'] = true
    sns_connection = SnsConnection.from_omniauth(auth)
    user = sns_connection.user
    if sns_connection.persisted? && user.present?
      user.from_omniauth(auth)
      user.save if user.changed
      sign_in_and_redirect user, notice: "Signed in!"
    else
      if sns_connection.provider == "facebook"
        user = User.new
        user.from_omniauth(auth)
        user.save
        sns_connection.update_attribute :user_id, user.id
        sign_in user
        redirect_to root_url
      else
        session["devise.user_attributes"] = sns_connection.attributes
        session["sns_connection_id"] = sns_connection.id
        redirect_to new_user_registration_url
      end
    end
  end
  alias_method :facebook, :all
end
