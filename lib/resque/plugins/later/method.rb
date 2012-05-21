module Resque::Plugins::Later::Method
  extend ActiveSupport::Concern

  module ClassMethods
    def later(method_name, opts={})
      puts "Later is being called on the model"

      alias_method "now_#{method_name}", method_name
      puts PerformLater.config.enabled?
      return unless PerformLater.config.enabled?
      
      define_method "#{method_name}" do |*args|
        puts "Now, we are actually starting to progress"
        puts ""
        loner          = opts.fetch(:loner, false)
        queue          = opts.fetch(:queue, "generic")
        klass          = PerformLater::Workers::ActiveRecord::Worker
        klass          = PerformLater::Workers::ActiveRecord::LoneWorker if loner

        args = PerformLater::ArgsParser.args_to_resque(args)

        puts [queue, klass, send(:class).name, send(:id), "now_#{method_name}", args]
        aaa = Resque::Job.create(queue, klass, send(:class).name, send(:id), "now_#{method_name}", args)
      end
    end
  end

  def perform_later(queue, method, *args)
    ActiveSupport::Deprecation.warn("perform_later will be deprecated in future versions, please use the later method on your models")
    
    if PerformLater.config.enabled?
      args = PerformLater::ArgsParser.args_to_resque(args)
      Resque::Job.create(queue, PerformLater::Workers::ActiveRecord::Worker, self.class.name, self.id, method, *args)
    else
      self.send(method, *args)
    end
  end
end