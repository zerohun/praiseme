class PeopleController < ApplicationController
  def index
    if params[:q].present?
      @friends = User.reorder("status desc").where("users.username like ?", "%#{params[:q]}%").page(params[:page]).per(15)
    else
      @friends = current_user.friends.reorder("status desc").page(params[:page]).per(15)
    end
  end
end
