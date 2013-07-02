#
# Made By KAI
#

require File.dirname(__FILE__) + '/../../config/environment.rb'


namespace :user_stamp do
  
  task :delete_empty_user_stamp  do

    @exist_list =  UserStamp.joins("join users on users.id = user_stamps.user_id ").joins("join compliments on users.id = compliments.receiver_id")
    @exist_list = pluck("user_stamps.id")
    @exist_list = @list.uniq
    UserStamp.where.not(id: @exist_list).destroy_all


  end
end
