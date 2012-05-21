module PerformLater
  module Workers
    module Objects
      class Worker
        def self.perform(klass_name, method, *args)
          args = PerformLater::ArgsParser.args_from_resque(args)
          klass_name.constantize.send(method, *args)
        end
      end
    end
  end
end
