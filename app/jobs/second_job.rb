class SecondJob < ApplicationJob
  def perform
    Rails.logger.warn "SecondJob - Tenant: #{Apartment::Tenant.current}"
  end
end
