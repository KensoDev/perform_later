module ObjectPerformLater

  def perform_later(queue, method, *args)
    worker = PerformLater::Workers::Objects::Worker
    perform_later_enqueue(worker, queue, method, args)
  end

  def perform_later!(queue, method, *args)
    worker = PerformLater::Workers::Objects::LoneWorker
    perform_later_enqueue(worker, queue, method, args)
  end

  private 
    def perform_later_enqueue(worker, queue, method, args)
      if PerformLater.config.enabled?
        args = PerformLater::ArgsParser.args_to_resque(args)
        Resque::Job.create(queue, worker, self.name, method, *args)
      else
        self.send(method, *args)
      end  
    end
end

Object.send(:include, ObjectPerformLater)

