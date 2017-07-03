require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require 'travis/yaml'
require 'models/result'
require 'models/message'

module Checker
  class Application < Sinatra::Application
    register Travis::SSO

    get '/' do
      headers['Content-Type'] = 'application/json'
      JSON.dump(results: Result.count, messages: Message.count)
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
