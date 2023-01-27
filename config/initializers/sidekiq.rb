# Silence the ascii banner
if defined?(::Sidekiq::CLI)
  class Sidekiq::CLI
    def print_banner
    end
  end
end

ActiveJob::Base.queue_adapter = :sidekiq

Sidekiq.configure_server do |config|
  config.logger.level = Logger::WARN
end
