require_relative './lib/checker'
require 'rack/ssl'
require 'raven'

Raven.configure do |config|
  config.dsn = ENV['SENTRY_URL']
end

use Raven::Rack
use Rack::Static, urls: ['/js', '/css', '/favicon.ico', '/img'], root: 'public'
use Rack::SSL if Sinatra::Application.production?
run Checker::Application
