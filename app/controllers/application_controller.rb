class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :store_current_page_url
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_decision

  protected

  def store_current_page_url
    cookies[:last_page_url] = request.url if current_user.blank? && params[:controller] != "sessions"
  end

  def layout_decision
    current_user.present?? "application" : "before_login"
  end

end
