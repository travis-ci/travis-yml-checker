require 'models/result'
require 'models/message'
require 'travis/yaml'

module Checker
  class ConfigWorker
    include Sidekiq::Worker

    def perform(original_config, request_id, repo_id, owner_type, owner_id)
      config = Travis::Yaml.load(original_config)
      result = Result.create(
        original_config: original_config,
        request_id:      request_id,
        repo_id:         repo_id,
        owner_type:      owner_type,
        owner_id:        owner_id,
        parsed_config:   config.serialize
      )

      messages = config.msgs
      messages.each do |message|
        level, key, code, args = message
        Message.create(
          level:      level,
          key:        key,
          code:       code,
          args:       args,
          result_id:  result.id
        )
      end
    end
  end

end
