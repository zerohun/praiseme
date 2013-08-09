class Admin::DashboardsController < Admin::ApplicationController
  def index

    now_month = Date.today.month
    @compliment = Compliment.where('extract(month from created_at) = ?' , now_month)
    @new_compliment = Compliment.where("updated_at >= ? and updated_At < ?",Date.yesterday.to_time, Date.today.to_time)
    @new_user = User.where("users.updated_at >= ? and users.updated_At < ?",Date.yesterday.to_time, Date.today.to_time)


  end

  def show
  end

  def new
  end

  def create
  
  end

  def edit
  end


  def destroy
  end
  
  private
  def dashboard_params
  end
end
