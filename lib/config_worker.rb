module Checker
  class ConfigWorker
    include Sidekiq::Worker

    def perform(original_config, request_id, repo_id, owner_type, owner_id)
      # here we use travis-yml to parse the config

      #create the Config record

      #parse the config

      #write the parsed_config to the config record, create any message records if the parsed_config includes messages

    end

  end
end
