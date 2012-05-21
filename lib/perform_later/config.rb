module PerformLater
  class Config
    def self.enabled=(value)
      @enabled = value
    end

    def self.enabled?
      !!@enabled
    end
  end
end