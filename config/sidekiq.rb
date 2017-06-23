require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require_relative '../lib/worker'
require_relative '../lib/database'

Travis::Database.connect
