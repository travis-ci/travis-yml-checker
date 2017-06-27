$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'

require 'database'
Checker::Database.connect

require 'sidekiq'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
end

require 'build_worker'
require 'config_worker'
