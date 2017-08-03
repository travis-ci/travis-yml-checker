require_relative './lib/checker'
require 'rack/ssl'
require 'raven'

use Raven::Rack
use Rack::Static, urls: ['/js', '/css', '/favicon.ico', '/img'], root: 'public'
use Rack::SSL if Sinatra::Application.production?
run Checker::Application
