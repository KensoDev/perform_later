module ObjectPerformLater
  def perform_later(queue, method, *args)
    if PerformLater.config.enabled?
      args = PerformLater::ArgsParser.args_to_resque(args)
      Resque::Job.create(queue, ObjectWorker, self.name, method, *args)
    else
      self.send(method, *args)
    end
  end
end

Object.send :include, ObjectPerformLater