module Checker
  class BuildWorker
    include Sidekiq::Worker

    def perform(build_id)
      #write the build id to the config record
    end

  end
end
