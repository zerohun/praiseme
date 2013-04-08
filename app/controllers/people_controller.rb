class PeopleController < ApplicationController
  def index
    if params[:q].present?
      @friends = User.search(params[:q], 
                             :sql => {:joins => :sns_connections, :select => "users.*, sns_connections.uid as uid" },
                             :page => params[:page],
                             :per_page => 15
                            )
    else
      @friends = current_user.friends.reorder("status desc").page(params[:page]).per(15)
    end
  end
end
