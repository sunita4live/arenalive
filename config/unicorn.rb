# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.

# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

# WARNING: See config/application.rb under "Relative url support" for the list of
# other files that need to be changed for relative url support
#
# ENV['RAILS_RELATIVE_URL_ROOT'] = "/gitlab"

# Read about unicorn workers here:
# http://doc.gitlab.com/ee/install/requirements.html#unicorn-workers
# paths
app_path = "/var/www/arenalive/"
working_directory "#{app_path}/current"
pid               "#{app_path}/current/tmp/pids/unicorn.pid"

# listen
listen "/tmp/unicorn.arenalive.sock", :backlog => 64

# logging
stderr_path '/var/www/arenalive/shared/log/unicorn.log'
stdout_path '/var/www/arenalive/shared/log/unicorn.log'
worker_processes 3

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "/var/www/arenalive" # available in 0.94.0+

# Listen on both a Unix domain socket and a TCP port.
# If you are load-balancing multiple Unicorn masters, lower the backlog
# setting to e.g. 64 for faster failover.
#listen "/var/www/arenalive/tmp/sockets/unicorb.socket", :backlog => 1024


# nuke workers after 30 seconds instead of 60 seconds (the default)
#
# NOTICE: git push over http depends on this value.
# If you want be able to push huge amount of data to git repository over http
# you will have to increase this value too.
#
# Example of output if you try to push 1GB repo to GitLab over http.
#   -> git push http://gitlab.... master
#
#   error: RPC failed; result=18, HTTP code = 200
#   fatal: The remote end hung up unexpectedly
#   fatal: The remote end hung up unexpectedly
#
# For more information see http://stackoverflow.com/a/21682112/752049
#
timeout 60

# feel free to point this anywhere accessible on the filesystem
#pid "/var/www/arenalive/tmp/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, some applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
#stderr_path "/var/www/arenalive/log/unicorn.stderr.log"
#stdout_path "/var/www/arenalive/log/unicorn.stdout.log"
# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

# preload
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end