require 'rubygems'
require 'bundler/setup'
require 'rack/ssl'
Bundler.require :default

require 'travis/yaml'
require 'travis/sso'
require 'travis/config'
require 'models/result'
require 'models/message'

module Checker
  class Application < Sinatra::Application
    # use travis-config to define admins
    Travis::Config.class_eval do
      define admins: []
    end

    config = Travis::Config.load(:files, :keychain, :heroku)

    puts ENV['ENV']
    puts config.inspect

    # authenticate users
    enable :sessions
    use Travis::SSO, mode: :session,
      authorized?: -> u { config.admins.include? u['login'] }

    get '/' do
      @results_count = Result.count
      @messages_count = Message.count
      slim :checker
    end

    get '/result/:id' do
      @result = Result.find params[:id]
      @messages = @result.messages
      slim :result
    end

    get '/request/:id' do
      result_id = Result.find_by(request_id: params[:id]).id
      redirect "result/#{result_id}"
    end
  end
end
