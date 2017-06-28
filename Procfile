web: bundle exec puma -C ./config/puma.rb
sidekiq: bundle exec sidekiq -e ${RACK_ENV:-development} -r ./config/sidekiq.rb -q yml -c ${SIDEKIQ_CONCURRENCY:-10}
console: bundle exec irb -I lib -r checker.rb
