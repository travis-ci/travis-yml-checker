require 'active_record'
require 'yaml'

module Checker
  module Database
    def self.connect
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.default_timezone = :utc
    end

    def self.config
      config = YAML.load(File.read(File.expand_path('../../config/database.yml', __FILE__)))
      config = config[ENV.fetch('RACK_ENV', 'development')]
      config['url'] = ENV['DATABASE_URL'] if ENV['DATABASE_URL']
      config
    end
  end
end
