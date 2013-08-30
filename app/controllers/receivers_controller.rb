class ReceiversController < ApplicationController
  def index
    @receivers = current_user.followings.joins(:followee).reorder("followings.rank desc")
    if params[:q].present?
      @receivers = @receivers.where("users.username like ? or concat(users.first_name, users.last_name) like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    end
    @receivers = @receivers.page(params[:page]).per(20)
  end
end
