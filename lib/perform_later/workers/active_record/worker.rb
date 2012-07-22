module PerformLater
  module Workers
    module ActiveRecord
      class Worker < PerformLater::Workers::Base
        def self.perform(klass, id, method, *args)
          args         = PerformLater::ArgsParser.args_from_resque(args)
          runner_klass = klass.constantize
          record       = runner_klass.find(id)
          
          perform_job(record, method, args)
        end
      end
    end
  end
end