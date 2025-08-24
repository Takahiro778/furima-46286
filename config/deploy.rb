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

# どのコマンドにも効く環境変数（assets:precompile 含む）
set :default_env, { 'BUNDLE_FORCE_RUBY_PLATFORM' => 'true' }

# Bundler（mysql2 のビルド設定だけ残す）
set :bundle_env_variables, {
  'BUNDLE_FORCE_RUBY_PLATFORM' => 'true',
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

# --- ここから追加タスク（確実に ruby プラットフォームで固定＆古い Nokogiri を掃除）---
namespace :deploy do
  desc 'Bundlerにforce_ruby_platformをローカル設定'
  task :force_ruby_platform do
    on roles(:app) do
      within release_path do
        execute "#{fetch(:rbenv_path)}/bin/rbenv exec bundle config --local force_ruby_platform true"
      end
    end
  end

  desc '共有bundleからprecompiled版のnokogiriを削除'
  task :purge_nokogiri do
    on roles(:app) do
      execute :bash, '-lc', "rm -rf #{shared_path}/bundle/ruby/*/gems/nokogiri-* "\
                            "#{shared_path}/bundle/ruby/*/specifications/nokogiri-*.gemspec "\
                            "#{shared_path}/bundle/ruby/*/extensions/*/*/nokogiri-* || true"
    end
  end

  task :restart do
    invoke 'unicorn:restart'
  end
end

before 'bundler:install', 'deploy:force_ruby_platform'
before 'bundler:install', 'deploy:purge_nokogiri'
after  'deploy:publishing', 'deploy:restart'
# --- 追加ここまで ---
