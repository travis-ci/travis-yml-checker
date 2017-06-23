module Travis
  class Worker
    include Sidekiq::Worker

    def perform(original_config, request_id, repo_id, owner_type, owner_id)
      # here we use travis-yml to parse the config
      
    end

  end
end
