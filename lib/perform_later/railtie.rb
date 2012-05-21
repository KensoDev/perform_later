module PerformLater
  class Railtie < ::Rails::Railtie
    config.perform_later = PerformLater::Config
  end
end