module Checker
  class LibratoWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'yml'

    def perform(levels, parse_time)
      queue = Librato::Metrics::Queue.new
      grouped_levels = levels.group_by{|level| level}.values.map{|x| [x.first, x.length]}.to_h
      grouped_levels.each do | level, count |
        queue.add "yml.messages.level.#{level}" => count
      end
      queue.add "yml.parse.time" => parse_time
      queue.submit
      puts "Metrics submitted to Librato..."

    rescue Librato::Metrics::CredentialsMissing
      puts "Librato credentials missing"
    end
  end
end
