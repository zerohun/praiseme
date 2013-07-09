env :PATH, ENV['PATH']

every 15.minutes do
  rake "user_stamp:delete_empty_user_stamp", :output => "log/empty_user_stamp_test.log", :environment => ENV['RAILS_ENV']
end

every 1.day , :at => "1:30 am" do
  rake "user_stamp:delete_empty_user_stamp", :output => "log/empty_user_stamp.log", :environment => ENV['RAILS_ENV']
end

every 1.day , :at => "1:20 am" do
  rake "search_suggestion:stamp_index", :output => "log/stamp_indexing_log.log", :environment => ENV['RAILS_ENV']
end
