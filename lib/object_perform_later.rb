module ObjectPerformLater
  def perform_later(queue, method, *args)
    return self.send(method, *args) unless PerformLater.config.enabled?

    worker = PerformLater::Workers::Objects::Worker
    perform_later_enqueue(worker, queue, method, *args)
  end

  def perform_later!(queue, method, *args)
    return self.send(method, *args) unless PerformLater.config.enabled?

    return "EXISTS!" if loner_exists(method, *args)

    worker = PerformLater::Workers::Objects::LoneWorker
    perform_later_enqueue(worker, queue, method, *args)
  end

  private 
    def loner_exists(method, *args)
      digest = PerformLater::PayloadHelper.get_digest(self.name, method, *args)

      return true unless Resque.redis.get(digest).blank?
      Resque.redis.set(digest, 'EXISTS')
      return false
    end

    def perform_later_enqueue(worker, queue, method, *args)
      args = PerformLater::ArgsParser.args_to_resque(*args)
      Resque::Job.create(queue, worker, self.name, method, *args)
    end
end

Object.send(:include, ObjectPerformLater)