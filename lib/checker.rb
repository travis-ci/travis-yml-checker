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
      @messages = Message.all
      levels = @messages.pluck(:level).uniq

      levels.each do |level|
        instance_variable_set("@#{level}", @messages.where(level: level))
        # instance_variable_set("@#{level}_codes", "@#{level}".group_by(&:code)
      end

      @info_codes = @info.group_by(&:code)
      @warn_codes = @warn.group_by(&:code)
      @error_codes = @error.group_by(&:code)

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
