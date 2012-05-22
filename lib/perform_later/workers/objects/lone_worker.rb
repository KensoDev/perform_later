module PerformLater
  module Workers
    module Objects
      class LoneWorker
        def self.perform(klass_name, method, *args)
          # Remove the loner flag from redis
          digest = Digest::MD5.hexdigest({:class => klass, :args => args}.to_s)
          Resque.redis.del(digest)

          args = PerformLater::ArgsParser.args_from_resque(args)
          klass_name.constantize.send(method, *args)
        end
      end
    end
  end
end
