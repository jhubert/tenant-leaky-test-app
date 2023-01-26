module Dbgemtest
  class Railtie < Rails::Railtie
    initializer "dbgemtest", after: :load_config_initializers do |app|
      puts "dbgemtest"
    end
  end
end
