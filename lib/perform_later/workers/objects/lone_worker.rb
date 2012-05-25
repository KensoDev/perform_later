module PerformLater
  module Workers
    module Objects
      class LoneWorker < PerformLater::Workers::BaseWorker
        def self.perform(klass_name, method, *args)
          digest = PerformLater::PayloadHelper.get_digest(klass_name, method, args)
          Resque.redis.del(digest)

          arguments = PerformLater::ArgsParser.args_from_resque(args)
          
          perform_job(klass_name.constantize, method, arguments)
        end
      end
    end
  end
end
