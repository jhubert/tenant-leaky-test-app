class SecondJob < ApplicationJob
  def perform
    Rails.logger.warn "SecondJob tenant=#{Apartment::Tenant.current} queue_adapter=#{self.class.queue_adapter_name} pid=#{Process.pid}"
  end
end
