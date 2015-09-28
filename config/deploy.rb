require "bundler/capistrano"
require "rvm/capistrano"
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'arenalive'
#set :repo_url, 'https://github.com/sunita4live/arenalive.git'
set :repo_url, 'git@github.com:sunita4live/arenalive.git'

set :deploy_to, '/var/www/arenalive/'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git
set :scm, :git
# Default value for :format is :pretty
# set :format, :pretty
set :branch, 'master'
# Default value for :log_level is :debug
# set :log_level, :debug
set :keep_releases, 5
# Default value for :pty is false
# set :pty, true
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :format, :pretty
set :log_level, :debug

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :rvm1_ruby_version, "ruby 2.2.2p95"
set :rvm_ruby_version, '2.2.2'
# Default value for keep_releases is 5
# set :keep_releases, 5

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/production/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end

  
end
