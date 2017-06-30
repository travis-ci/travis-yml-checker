require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require 'database'
Checker::Database.connect

require 'travis/yaml'
require 'models/result'
require 'models/message'
