require 'sidekiq-ent/web'

ActiveJob::Base.queue_adapter = :sidekiq

Sidekiq.configure_server do |config|
  config.logger.level = Logger::WARN
end
