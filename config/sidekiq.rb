$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler/setup'

require 'database'
Checker::Database.connect

require 'travis/metrics'
logger = Logger.new(STDOUT)
metrics_config = {
  reporter: 'librato',
  email: ENV['LIBRATO_EMAIL'],
  token: ENV['LIBRATO_TOKEN'],
  source: ENV['LIBRATO_SOURCE'],
}
Travis::Metrics.setup(metrics_config, logger)

require 'sidekiq'
require 'travis/metrics/sidekiq'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }

  config.server_middleware do |chain|
    chain.add Travis::Metrics::Sidekiq
  end
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

if ENV['ENV'] == 'production'
  require 'raven'
  Raven.configure do |config|
    return unless ENV['SENTRY_DSN']
    config.dsn = ENV['SENTRY_DSN']
  end
end

require 'build_worker'
require 'config_worker'
require 'librato_worker'
