module PerformLater
  class Plugins
    def self.finder_class
      @@finder_class ||= nil
    end

    def self.add_finder(klass)
      if klass.respond_to?(:find)
        @@finder_class = klass
      end
    end
  end
end