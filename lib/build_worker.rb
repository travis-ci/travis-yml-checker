require 'models/result'

module Checker
  class BuildWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'yml'

    def perform(build_id, request_id)
      result = Result.find_or_create_by(request_id: request_id)
      result.update_attributes(build_id: build_id)
    end
  end
end
