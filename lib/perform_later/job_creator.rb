module PerformLater
  class JobCreator
    
    attr_reader :queue, :worker, :klass_name, :id, :method
    attr_accessor :args

    def initialize(queue, worker, klass_name, id, method, *args)
      @queue       = queue
      @worker      = worker
      @klass_name  = klass_name
      @id          = id
      @method      = method
      @args        = args
    end

    def enqueue(delay=nil)
      return Resque.enqueue_in_with_queue(queue, delay, worker, klass_name, id, method, args) if delay 
      Resque::Job.create(queue, worker, klass_name, id, method, *args)
    end
  end
end
