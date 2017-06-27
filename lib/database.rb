require 'active_record'
require 'yaml'

module Checker
  module Database
    def self.connect
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.default_timezone = :utc
    end

    def self.config
      if ['production', 'staging'].include?(ENV['RACK_ENV'])
        { database: ENV['DATABASE_URL'], pool: ENV['DB_POOL'], adapter: 'postgresql', timeout: 5000 }
      else
        config = YAML.load(File.read(File.expand_path('../../db/config.yml', __FILE__)))
        config[ENV.fetch('RACK_ENV', 'development')]
      end
    end
  end
end
