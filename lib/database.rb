require 'active_record'
require 'yaml'

module Travis
  module Database
    def self.connect
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.default_timezone = :utc
    end

    def self.config
      if ENV['ENV'] == 'production'
        ENV['DATABASE_URL']
      else
        config = YAML.safe_load(File.read(File.expand_path('../../db/config.yml', __FILE__)))
        config[ENV.fetch('ENV', 'development')]
      end
    end
  end
end
