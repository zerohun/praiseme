class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :store_current_page_url
  before_action :record_user_visit
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

  def record_user_visit
    if current_user.present?
      current_user.update_attribute :last_visited_on, Date.today if current_user.last_visited_on != Date.today
    end
  end
end
