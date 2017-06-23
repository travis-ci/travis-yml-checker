web: bundle exec puma -C ./config/puma.rb
sidekiq: bundle exec sidekiq -e ${RACK_ENV:-development} -r ./config/sidekiq.rb -q yml
console: bundle exec irb -I lib -r checker.rb
