module PerformLater
  module Workers
    module Objects
      class Worker
        def self.perform(klass_name, method, *args)
          arguments = PerformLater::ArgsParser.args_from_resque(args)

          if arguments.any?
            argument =  arguments.size == 1 ? arguments.first : arguments
            klass_name.constantize.send(method, argument)
          else
            klass_name.constantize.send(method)
          end
        end
      end
    end
  end
end
