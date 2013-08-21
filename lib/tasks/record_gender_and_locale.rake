
require File.dirname(__FILE__) + '/../../config/environment.rb'
namespace :users do
  task :record_gender_and_locale  do
    User.find_each do |u|
      begin
        fobj = User.first.facebook.get_object(u.uid)
        u.gender = 1 if fobj["gender"] == "male"
        u.gender = 2 if fobj["gender"] == "female"
        u.local = fobj["locale"]
        u.save
        puts u.id
        puts "success"
      rescue Exception => e
        puts u.id
        puts "filed"
      end
    end

  end
end

