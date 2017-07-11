require 'models/result'

module Checker
  class BuildWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'yml'

    def perform(build_id, request_id)
      result = Result.find_or_create_by(request_id: request_id)
      result.update_attributes(build_id: build_id)
      if slack_notifier
        slack_notifier.ping "A new result for build [#{build_id}](https://yml.travis-ci.org/request/#{request_id})"
      end
    end
  end
end
