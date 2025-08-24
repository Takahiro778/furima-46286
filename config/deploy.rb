# Capistrano をこのバージョンで固定
lock '3.19.2'

set :application, 'furima-46286'
set :repo_url,    'git@github.com:Takahiro778/furima-46286.git'
set :branch,      'main'

# デプロイ先
set :deploy_to, '/var/www/furima-46286'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '3.2.0'
set :rbenv_path, '/home/ec2-user/.rbenv'
append :rbenv_map_bins, 'rake', 'gem', 'bundle', 'ruby', 'rails'

# 既存の deploy.rb の該当部分だけ差し替え/追記

# Bundler 環境変数
set :bundle_env_variables, {
  # これでバイナリ版ではなく ruby プラットフォームでビルドさせる
  'BUNDLE_FORCE_RUBY_PLATFORM' => 'true',

  # mysql2 のビルド設定はそのまま
  'BUNDLE_BUILD__MYSQL2' => '--with-mysql-config=/usr/bin/mysql_config --with-openssl-lib=/usr/lib64 --with-openssl-include=/usr/include'
}

# 共有（symlink）
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/master.key')
set :linked_dirs,  fetch(:linked_dirs,  []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
  'vendor/bundle', 'public/system', 'public/uploads', 'public/assets'
)

# SSH
set :ssh_options, {
  auth_methods: %w[publickey],
  keys: ['~/.ssh/furima-key.pem']
}

# Unicorn
set :unicorn_pid,         -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
