require_relative './lib/checker'
use Rack::Static, urls: ['/js', '/css', '/favicon.ico', '/img'], root: 'public'
run Checker::Application
