module PerformLater
  module Workers
    module ActiveRecord
      class LoneWorker
        def self.perform(klass, id, method, *args)
          # Remove the loner flag from redis
          digest = PerformLater::PayloadHelper.get_digest(klass, method_name, args)
          Resque.redis.del(digest)

          args = PerformLater::ArgsParser.args_from_resque(args)
          runner_klass = eval(klass)
          
          record = runner_klass.where(:id => id).first
          record.send(method, *args) if record
        end
      end
    end
  end
end