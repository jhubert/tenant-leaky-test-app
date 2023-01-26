class FirstJob < ApplicationJob
  def perform
    SecondJob.perform_later

    Rails.logger.warn "FirstJob - Tenant: #{Apartment::Tenant.current}"
  end
end
