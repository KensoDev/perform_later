module PerformLater
  module Workers
    module Objects
      class LoneWorker
        def self.perform(klass_name, method, *args)
          # 
          digest = PerformLater::PayloadHelper.get_digest(klass_name, method, args)
          Resque.redis.del(digest)

          args = PerformLater::ArgsParser.args_from_resque(args)
          
          if args.length > 0
            klass_name.constantize.send(method, args)
          else
            klass_name.constantize.send(method)
          end
        end
      end
    end
  end
end
