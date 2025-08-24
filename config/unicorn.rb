# Capistrano 用（current/shared 構成）
app_path = File.expand_path('../../../', __FILE__)  # => /var/www/アプリ配下

worker_processes 1
working_directory "#{app_path}/current"

pid "#{app_path}/shared/tmp/pids/unicorn.pid"
listen "#{app_path}/shared/tmp/sockets/unicorn.sock"

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

timeout 60
preload_app true
check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
