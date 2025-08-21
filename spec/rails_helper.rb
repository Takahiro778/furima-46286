# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec/fixtures')
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # FactoryBotの省略記法を有効にする
  config.include FactoryBot::Syntax::Methods

  # Rails 7.1 + RSpec のDBコネクション問題を解決する設定
  config.around do |example|
    ActiveRecord::Base.connection_pool.with_connection do
      example.run
    end
  end
end
