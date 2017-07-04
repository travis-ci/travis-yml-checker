source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)) if ENV['DYNO']

gem 'activerecord', '~> 5.0'
gem 'pg'
gem 'safe_yaml'

gem 'sinatra'
gem 'redis'
gem 'redis-namespace'
gem 'sidekiq', '~> 4.2'
gem 'puma'
gem 'standalone_migrations'
gem 'sentry-raven'
gem 'slim'
gem 'rack-ssl'

gem 'travis-yml', git: 'https://github.com/travis-ci/travis-yml'
gem 'travis-config', git: 'https://github.com/travis-ci/travis-config'
gem 'travis-sso', git: 'https://github.com/travis-ci/travis-sso'

group :test do
  gem 'rspec'
  gem 'database_cleaner'
end
