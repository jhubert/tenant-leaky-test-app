# frozen_string_literal: true

Apartment.configure do |config|
  config.tenant_names = -> { %w[first second] }
end
