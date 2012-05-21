module PerformLater
  class Railtie < ::Rails::Railtie
    config.perform_later = PerformLater
  end
end