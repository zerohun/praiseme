class SessionsController < Devise::SessionsController
  layout 'before_login'

  def new
    redirect_to "/users/auth/facebook"
  end
end
