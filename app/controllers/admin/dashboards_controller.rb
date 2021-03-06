class Admin::DashboardsController < Admin::ApplicationController
  def index

    now_month = Date.today.month
    @compliment = Compliment.where('extract(month from created_at) = ?' , now_month)
 
    if params[:new_user].present?
      pre_day = Time.now 
      more_pre_day = (Date.today - 6.days).to_time 
      @new_user=User.where("joined_at >= ? and joined_at < ? and status = 1",more_pre_day,pre_day)
      @new_user = @new_user.order('joined_at desc')
      
    
    else

      @new_compliment = []
      @new_user = []
      @new_active_user = []
      @new_stamp = []
      @new_user_stamp = []
      @new_comment = []

      (0..7).each do |i| 
        if i == 0
          pre_day = Time.now 
          more_pre_day = Date.today.to_time 
        else
          pre_day = (Date.today - (i-1).days).to_time 
          more_pre_day = (Date.today - i.days).to_time 
        end

        @new_compliment.push(Compliment.where("updated_at >= ? and updated_at < ?",more_pre_day,pre_day).count)
        @new_user.push(User.where("users.created_at >= ? and users.created_at < ?",more_pre_day,pre_day).count)
        @new_active_user.push(User.where("users.joined_at >= ? and users.joined_at < ? and users.status = 1",more_pre_day,pre_day).count)
        @new_stamp.push(Stamp.where("updated_at >= ? and updated_at < ?",more_pre_day, pre_day).count)
        @new_user_stamp.push(UserStamp.where("updated_at >= ? and updated_at < ?",more_pre_day, pre_day).count)
        @new_comment.push(Comment.where("updated_at >= ? and updated_at < ?",more_pre_day, pre_day).count)

      end

    end
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
