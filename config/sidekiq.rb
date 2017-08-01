$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'

require 'database'
Checker::Database.connect

require 'sidekiq'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
end

require 'slack-notifier'
module SlackClient
  def ping(*args)
    notifier && notifier.ping(*args)
  end

  def notifier
    return unless ENV['SLACK_URL']
    @notifier ||= Slack::Notifier.new ENV['SLACK_URL'], "username": "yml-checker", "icon_emoji": ":tessa-skin-tone-2:"
  end
end

require 'librato/metrics'
module LibratoClient
  extend self
  def authenticate
    return unless ( ENV['LIBRATO_EMAIL'] && ENV['LIBRATO_TOKEN'] )
    Librato::Metrics.authenticate ENV['LIBRATO_EMAIL'], ENV['LIBRATO_TOKEN']
  end
end

LibratoClient.authenticate

require 'raven'
Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
end
use Raven::Rack

require 'build_worker'
require 'config_worker'
require 'librato_worker'
