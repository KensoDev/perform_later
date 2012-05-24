module PerformLater
  module Workers
    module ActiveRecord
      class LoneWorker
        def self.perform(klass, id, method, *args)
          # Remove the loner flag from redis
          digest = PerformLater::PayloadHelper.get_digest(klass, method, args)
          Resque.redis.del(digest)

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