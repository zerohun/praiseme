class FacebookPostsController < ApplicationController
  def create_ask_opinion
    begin 
      current_user.facebook.put_wall_post("What do you think of me?", :link => "http://startglory.com/compliments/new?compliment[receiver_id]=#{current_user.id}", :picture => current_user.image_url, :name => current_user.username, :caption => "Startglory", :description => "What do you think of me?")
      render :json => "success"
    rescue Exception
      render :json => "failed"
    end

  end
end
