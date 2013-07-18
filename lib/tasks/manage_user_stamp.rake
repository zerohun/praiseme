#
# Made By KAI
#

require File.dirname(__FILE__) + '/../../config/environment.rb'


namespace :user_stamp do
  
  task :delete_empty_user_stamp  do

    #@exist_list =  UserStamp.joins("join users on users.id = user_stamps.user_id ").joins("join compliments on users.id = compliments.receiver_id")
    #@exist_list = @exist_list.pluck("user_stamps.id")
    #@exist_list = @exist_list.uniq
    #Stamp.where.not(id: @exist_list).destroy_all
    @exist_list =  Compliment.pluck(:stamp_id).uniq
    UserStamp.where.not(:stamp_id => @exist_list).destroy_all
  # @exist_list = Compliment.all.pluck("stamp_id").uniq
   # UserStamp.where.not(:stamp_id => @list).destroy_all


  end
end
