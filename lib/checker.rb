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
      @messages = Message.connection.exec_query("SELECT DISTINCT level, code, COUNT(*) FROM messages GROUP BY level, code;")
      .to_a
      .group_by{|h| h["level"]}.each{|_, v| v.each {|h| h.delete("level")}}

      # this query keeps timing out so will comment it out until I can work out how to optimize it
      # @erroring_repos = Result.connection.exec_query("SELECT COUNT (results.id), repo_id, MAX(results.created_at)
      #                                                 FROM results
      #                                                 INNER JOIN messages ON results.id = messages.result_id
      #                                                 WHERE messages.level = 'error'
      #                                                 GROUP BY repo_id
      #                                                 ORDER BY COUNT (results.id) DESC;").to_a

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

    get '/repo/:id' do
      @messages = Result.find_by(repo_id: params[:id]).messages
      slim :repo
    end

    get '/args/:code' do
      @messages = Message.where(code: params[:code])
      @args = @messages.group_by{|a| a.args }.sort_by{|arg, group| group.count }.reverse
      slim :args
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
