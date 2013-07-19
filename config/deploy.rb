require "bundler/capistrano"
set :current_path, "/root/praiseme"
require 'sidekiq/capistrano'
require "whenever/capistrano"


set :application, "praiseme"
set :repository,  "git@github.com:zerohun/praiseme.git"
set :scm, :git
set :ssh_options, {:forward_agent => true}
set :rails_env, "production"
set :branch, "origin/master"
set :deploy_to, "/root/praiseme"
set :user, "root"
set :password, "1324513245Choi"


server "96.126.103.89", :app, :web, :db, :primary => true

default_environment["RAILS_ENV"] = "production"
default_environment["RUBY_VERSION"] = "ruby-2.0.0-p195"
default_run_options[:shell] = 'bash'
default_environment["PATH"]         = "/usr/local/rvm/gems/ruby-2.0.0-p195/bin:/usr/local/rvm/rubies/ruby-2.0.0-p195/bin:/usr/local/rvm/rubies/ruby-2.0.0-p195@global/bin:/usr/local/rvm/rubies/ruby-2.0.0-p195/bin:/usr/local/rvm/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
default_environment["GEM_HOME"]     = "/usr/local/rvm/gems/ruby-2.0.0-p195"
default_environment["GEM_PATH"]     = "/usr/local/rvm/gems/ruby-2.0.0-p195:/usr/local/rvm/gems/ruby-2.0.0-p195@global"

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
    run "kill -s QUIT `cat #{deploy_to}/tmp/pids/unicorn.pid.oldbin`"
  end

  task :start do
    run "cd #{deploy_to} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop do
    run "kill -s QUIT `cat #{deploy_to}/tmp/pids/unicorn.pid`"
    run "kill -s QUIT `cat #{deploy_to}/tmp/pids/unicorn.pid.oldbin`"
  end

  task :reset do
    run "cd #{deploy_to}; bundle exec rake db:migrate:reset; bundle exec rake db:fixtures:load; bundle exec rake db:seed"
  end
end

namespace :deploy do
  namespace :assets do
    desc "Precompile assets on local machine and upload them to the server."
    task :precompile, roles: :web, except: {no_release: true} do
      run_locally "bundle exec rake assets:precompile RAILS_ENV=production --trace"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:/root/praiseme/public"
      end
    end
  end
end
