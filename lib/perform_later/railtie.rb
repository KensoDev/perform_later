module PerformLater
  class Railtie < ::Rails::Railtie
    config.later = PerformLater::Config
  end
end