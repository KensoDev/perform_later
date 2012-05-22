module PerformLater
  module Workers
    module ActiveRecord
      class LoneWorker
        def self.perform(klass, id, method, *args)
          # Remove the loner flag from redis
          digest = Digest::MD5.hexdigest({:class => klass, :args => args}.to_s)
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
