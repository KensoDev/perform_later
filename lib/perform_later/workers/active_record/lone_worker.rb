module PerformLater
  module Workers
    module ActiveRecord
      class LoneWorker < PerformLater::Workers::BaseWorker
        def self.perform(klass, id, method, *args)
          # Remove the loner flag from redis
          digest = PerformLater::PayloadHelper.get_digest(klass, method, args)
          Resque.redis.del(digest)

          args = PerformLater::ArgsParser.args_from_resque(args)
          runner_klass = eval(klass)
          
          record = runner_klass.where(:id => id).first

          perform_job(record, method, args)
        end
      end
    end
  end
end