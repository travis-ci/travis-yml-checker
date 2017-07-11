require 'models/result'

module Checker
  class BuildWorker
    include Sidekiq::Worker, SlackClient
    sidekiq_options queue: 'yml'

    def perform(build_id, request_id)
      result = Result.find_or_create_by(request_id: request_id)
      result.update_attributes(build_id: build_id)
      ping "A new result! Build [#{build_id}](https://yml.travis-ci.org/request/#{request_id}) has some `travis-yml` parsing :yay1:"
    end
  end
end
