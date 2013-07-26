class PeopleController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    if current_user.present?
      if params[:q].present?
        @friends = current_user.friends.where("users.username like ? or concat(users.first_name, users.last_name) like ?", "%#{params[:q]}%", "%#{params[:q]}%")
      #  @friends = User.search(params[:q], 
      #                        :sql => {:joins => :sns_connections, :select => "users.*, sns_connections.uid as uid" },
      #                         :page => params[:page],
      #                         :per_page => 15
      #                        )
      else
        @friends = current_user.friends.reorder("status desc")
      end
      @friends_count = @friends.count
    else
      @friends_count = User.count
      @friends = User.joins("left outer join user_stamps on users.id = user_stamps.user_id").group("users.id").select("users.*, sum(user_stamps.score) as total_score").reorder("total_score desc")
    end
    @friends = @friends.page(params[:page]).per(15)
  end

  def recommendations
    begin
      @friends = current_user.friends.order("RAND()").first(3)
    rescue Exception
    end
  end
end
