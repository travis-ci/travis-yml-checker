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

    config = Travis::Config.load

    # authenticate users
    enable :sessions
    use Travis::SSO, mode: :session,
      authorized?: -> u { config.admins.include? u['login'] }

    get '/' do
      @results_count = Result.count
      @messages_count = Message.count
      @messages = Message.connection.exec_query("select distinct level, code, count(*) from messages group by level, code;")
      .to_a
      .group_by{|h| h["level"]}.each{|_, v| v.each {|h| h.delete("level")}}

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
