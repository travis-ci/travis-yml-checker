require 'rubygems'
require 'bundler/setup'
Bundler.require :default

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
      #@messages = @result.messages
      erb :result
    end
  end
end
