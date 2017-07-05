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

    # authenticate users
    enable :sessions
    use Travis::SSO, mode: :session,
      authorized?: -> u { config.admins.include? u['login'] }

    get '/' do
      @results_count = Result.count
      @messages_count = Message.count
      @messages = Message.all.group_by(&:level).map do |level, msgs|
        [level, msgs.group_by(&:code).map { |group, msgs| [group, msgs.size] }]
      end.to_h

      slim :index
    end

    get '/result/:id' do
      @result = Result.find params[:id]
      @messages = @result.messages
      slim :result
    end

    get '/request/:id' do
      result = Result.find_by(request_id: params[:id])
      redirect "result/#{result.id}" if result
      slim :oops
    end

    #only works when ENV=production 
    error ActiveRecord::RecordNotFound do
      slim :oops
    end

    not_found do
      slim :oops
    end
  end
end
