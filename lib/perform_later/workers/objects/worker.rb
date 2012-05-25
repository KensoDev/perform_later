module PerformLater
  module Workers
    module Objects
      class Worker < PerformLater::Workers::Base
        def self.perform(klass_name, method, *args)
          arguments = PerformLater::ArgsParser.args_from_resque(args)

          perform_job(klass_name.constantize, method, arguments)
        end
      end
    end
  end
end
