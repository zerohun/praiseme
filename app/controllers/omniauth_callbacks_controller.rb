class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    cookies['need_to_check_location'] = true
    sns_connection = SnsConnection.sign_in_or_up(auth: auth)
    user = sns_connection.user
    sign_in user
    if cookies[:last_page_url].present?
      last_page_url = cookies[:last_page_url]
      cookies[:last_page_url] = nil
      redirect_to last_page_url
    else
      redirect_to root_url
    end
  end
  alias_method :facebook, :all
end
