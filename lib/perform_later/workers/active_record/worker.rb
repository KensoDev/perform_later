module PerformLater
  module Workers
    module ActiveRecord
      class Worker
        def self.perform(klass, id, method, *args)
          args = PerformLater::ArgsParser.args_from_resque(args)
          runner_klass = eval(klass)
          
          record = runner_klass.where(:id => id).first
          
          if args.length > 0
            record.send(method, *args) if record
          else
            record.send(method) if record
          end
        end
      end
    end
  end
end