module ActiveRecordPerformLater
  module InstanceMethods
    def perform_later(queue, method, *args)
      if ResquePerformLater.config['enabled']
        args = ResquePerformLater.args_to_resque(args)
        
        Resque::Job.create(queue,
          ActiveRecordWorker,
          self.class.name,
          self.id,
          method,
          *args)
      else
        self.send(method, *args)
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end

ActiveRecord::Base.send :include, ActiveRecordPerformLater