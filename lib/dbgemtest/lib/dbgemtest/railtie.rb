module Dbgemtest
  class Railtie < Rails::Railtie

    if ENV['BROKEN']
      initializer "dbgemtest", after: :load_config_initializers do |app|
        puts "dbgemtest broken #{__id__} #{Process.pid}"
      end
    else
      initializer "dbgemtest" do |app|
        puts "dbgemtest #{__id__} #{Process.pid}"
      end
    end
  end
end
