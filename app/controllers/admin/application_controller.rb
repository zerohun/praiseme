
class Admin::ApplicationController < ApplicationController

 before_filter :is_admin_login

 
  layout 'admin'

  def is_admin_login
    if current_user == nil || current_user.user_admin_type == 0
      redirect_to 'not_admin'
    end
  end
end
