module PerformLater
  module Workers
    module Objects
      class LoneWorker
        def self.perform(klass_name, method, *args)
          # 
          digest = PerformLater::PayloadHelper.get_digest(klass_name, method, args)
          Resque.redis.del(digest)

          args = PerformLater::ArgsParser.args_from_resque(args)
          klass_name.constantize.send(method, *args)
        end
      end
    end
  end
end
