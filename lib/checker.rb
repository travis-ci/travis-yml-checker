require 'rubygems'
require 'bundler/setup'
Bundler.require :default

module Checker
  class Application < Sinatra::Application
    register Travis::SSO

    get '/' do
      'Hello! From the outside!'
    end
  end
end
