module PerformLater
  module Workers
    module ActiveRecord
      class Worker
        include Resque::Plugins::UniqueJob
        
        def self.perform(klass, id, method, *args)
          args = PerformLater::ArgsParser.args_from_resque(args)
          runner_klass = eval(klass)
          
          record = runner_klass.where(:id => id).first
          record.send(method, *args) if record
        end
      end
    end
  end
end
