$: << File.expand_path('../../lib', __FILE__)
puts 'THIS HAS BEEN REQUIRED!'
require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require 'build_worker'
require 'config_worker'
require 'database'

Checker::Database.connect
