module PerformLater
  module Workers
    module Objects
      class Worker
        def self.perform(klass_name, method, *args)
          arguments = PerformLater::ArgsParser.args_from_resque(args)

          if arguments.any?
            if arguments.size == 1
              klass_name.constantize.send(method, arguments.first)
            else
              klass_name.constantize.send(method, *arguments)
            end
          else
            klass_name.constantize.send(method)
          end
        end
      end
    end
  end
end
