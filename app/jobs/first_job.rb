class FirstJob < ApplicationJob
  def perform
    SecondJob.perform_later

    Rails.logger.warn "FirstJob tenant=#{Apartment::Tenant.current} queue_adapter=#{self.class.queue_adapter_name} pid=#{Process.pid}"
  end
end
