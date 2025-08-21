# config/environments/test.rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. Enable on CI.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  # （Rails 7.1 では :rescuable がデフォ。必要に応じて :none に変えて例外を直接上げてもOK）
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  # ======= ここからテスト安定化用の追加設定 =======

  # ジョブを即時実行（テスト中に別スレッド/別Fiberを立てない）
  config.active_job.queue_adapter = :inline

  # DB を同期実行にする（バックグラウンド executor を使わない）
  config.active_record.async_query_executor = :inline

  # Fiber 単位の分離をやめ、従来通り Thread 単位にする（AR 7.1 の接続プール問題回避）
  config.active_support.isolation_level = :thread

  # ログを静かめに（見やすさ向上・速度改善）
  config.log_level = :warn
  config.active_record.verbose_query_logs = false
end
