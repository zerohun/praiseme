
require File.dirname(__FILE__) + '/../../config/environment.rb'
namespace :users do
  task :record_gender_and_locale  do
    User.find_each do |u|
      begin
        fobj = User.first.facebook.get_object(u.uid)
        u.gender = (fobj["gender"] ==  "male") ? 0:1
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

