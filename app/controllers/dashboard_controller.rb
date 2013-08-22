class DashboardController < ApplicationController
  def index
    @is_user_stamps = current_user.user_stamps.where("stamps.verb = ?", 0).reorder("user_stamps.score desc").limit(2)
    @has_user_stamps = current_user.user_stamps.where("stamps.verb = ?", 1).reorder("user_stamps.score desc").limit(2)
  end
end
