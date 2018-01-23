source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)) if ENV['DYNO']

gem 'activerecord', '~> 5.0'
gem 'pg'
gem 'safe_yaml'
gem 'slack-notifier'

gem 'sinatra'
gem 'redis'
gem 'redis-namespace'
gem 'sidekiq', '~> 4.2'
gem 'puma'
gem 'standalone_migrations'
gem 'sentry-raven'
gem 'slim'
gem 'rack-ssl'
gem 'librato-metrics'

gem 'travis-yml', git: 'https://github.com/travis-ci/travis-yml'
gem 'travis-config'
gem 'travis-sso', git: 'https://github.com/travis-ci/travis-sso'
gem 'travis-metrics', git: 'https://github.com/travis-ci/travis-metrics'

gem 'metriks',                 git: 'https://github.com/travis-ci/metriks'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

group :test do
  gem 'rspec'
  gem 'database_cleaner'
end
