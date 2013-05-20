set :application, "praiseme"
set :repository,  "git@github.com:zerohun/praiseme.git"
set :scm, :git
set :ssh_options, {:forward_agent => true}
set :rails_env, "production"
set :branch, "origin/master"
set :deploy_to, "/home/pi/praiseme"
set :user, "pi"
set :password, "13245Choi"

server "27.35.39.36", :app, :web, :db, :primary => true

default_environment["RAILS_ENV"] = "production"
default_environment["RUBY_VERSION"] = "ruby-2.0.0-p0"
default_run_options[:shell] = 'bash'
default_environment["PATH"]         = "/home/pi/.rvm/gems/ruby-2.0.0-p0/bin:/home/pi/.rvm/rubies/ruby-2.0.0-p0/bin:/home/pi/.rvm/rubies/ruby-2.0.0-p0@global/bin:/home/pi/.rvm/rubies/ruby-2.0.0-p0/bin:/home/pi/.rvm/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
default_environment["GEM_HOME"]     = "/home/pi/.rvm/gems/ruby-2.0.0-p0"
default_environment["GEM_PATH"]     = "/home/pi/.rvm/gems/ruby-2.0.0-p0:/home/pi/.rvm/gems/ruby-2.0.0-p0@global"


namespace :deploy do
  task :default do
    update
    restart
  end

  task :migrate do
    run "cd #{deploy_to}; bundle exec rake db:migrate"
  end

  task :bundle do
    run "cd #{deploy_to}; bundle install"
  end

  task :update do
    transaction do
      update_code
    end
  end

  task :update_code do
    run "cd #{deploy_to}; git fetch origin; git reset --hard #{branch}"
  end

  task :restart do
    run "kill -s USR2 `cat #{deploy_to}/tmp/pids/unicorn.pid`"
  end

  task :start do
    run "cd #{deploy_to} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop do
    run "kill -s QUIT `cat #{deploy_to}/tmp/pids/unicorn.pid`"
  end

  task :reset do
    run "cd #{deploy_to}; bundle exec rake db:migrate:reset; bundle exec rake db:fixtures:load; bundle exec rake db:seed"
  end

end

