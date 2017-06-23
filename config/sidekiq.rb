require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require_relative '../lib/build_worker'
require_relative '../lib/config_worker'
require_relative '../lib/database'

Checker::Database.connect
