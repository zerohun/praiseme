class PersonalNewsFeedController < ApplicationController
  def index
    binding.pry
    @personal_feeds = Compliment.where("sender_id = ? or receiver_id = ?",@user.id,@user.id)
    @personal_feeds.order('created_at desc').page(params[:page]).per(10)

  
  end

end
