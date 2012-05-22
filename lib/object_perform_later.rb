module ObjectPerformLater
  def perform_later(queue, method, *args)
    args = PerformLater::ArgsParser.args_to_resque(args)

    worker = PerformLater::Workers::Objects::Worker
    perform_later_enqueue(worker, queue, method, args)
  end

  def perform_later!(queue, method, *args)
    args = PerformLater::ArgsParser.args_to_resque(args)
    
    digest = PerformLater::PayloadHelper.get_digest(self.name, method, args)
    return "EXISTS!" unless Resque.redis.get(digest).blank?
    Resque.redis.set(digest, 'EXISTS')

    worker = PerformLater::Workers::Objects::LoneWorker
    perform_later_enqueue(worker, queue, method, args)
  end

  private 
    def perform_later_enqueue(worker, queue, method, args)
      if PerformLater.config.enabled?
        Resque::Job.create(queue, worker, self.name, method, *args)
      else
        args = PerformLater::ArgsParser.args_from_resque(args)
        self.send(method, *args)
      end  
    end
end

Object.send(:include, ObjectPerformLater)

