module PerformLater
  module Workers
    module Objects
      class Worker
        def self.perform(klass_name, method, *args)
          args = PerformLater::ArgsParser.args_from_resque(args)
          if args.length > 0
            klass_name.constantize.send(method, args)
          else
            klass_name.constantize.send(method)
          end
        end
      end
    end
  end
end
