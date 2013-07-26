class SessionsController < Devise::SessionsController
  layout 'before_login'
end
