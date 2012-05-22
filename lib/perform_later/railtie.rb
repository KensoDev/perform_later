module PerformLater
  class Railtie < ::Rails::Railtie
    config.perf_later = PerformLater::Config
  end
end