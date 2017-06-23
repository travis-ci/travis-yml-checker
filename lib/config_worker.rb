require 'models/config'

module Checker
  class ConfigWorker
    include Sidekiq::Worker

    def perform(original_config, request_id, repo_id, owner_type, owner_id)
      #create the Config record
      Config.create(
        original_config: original_config,
        request_id:      request_id,
        repo_id:         repo_id,
        owner_type:      owner_type,
        owner_id:        owner_id
      )

      #parse the config

      #write the parsed_config to the config record, create any message records if the parsed_config includes messages

    end

  end
end
