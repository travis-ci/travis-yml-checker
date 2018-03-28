require 'models/result'
require 'models/message'
require 'travis/yaml'

module Checker
  class ConfigWorker
    include Sidekiq::Worker, SlackClient
    sidekiq_options queue: 'yml'

    def perform(original_config, request_id, repo_id, owner_type, owner_id)
      config = Travis::Yaml.load(original_config)
      parse_time = Benchmark.realtime do
        @parsed_config = config.serialize
      end
      result = Result.find_or_create_by(request_id: request_id)
      result.update_attributes(
        original_config: original_config,
        request_id:      request_id,
        repo_id:         repo_id,
        owner_type:      owner_type,
        owner_id:        owner_id,
        parsed_config:   @parsed_config,
        parse_time:      parse_time.to_f
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

      ping "A new result! Parsing the config for request [#{request_id}](https://yml-checker.travis-ci.org/request/#{request_id}) has produced #{messages.count} messages."

      #enqueue seding of metrics to librato
      LibratoWorker.perform_async(messages.map(&:first), parse_time.to_f)
    end
  end

end
