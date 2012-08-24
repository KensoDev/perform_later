module Resque::Plugins::Later::Method
  extend ActiveSupport::Concern

  module ClassMethods
    def later(method_name, opts={})
      alias_method "now_#{method_name}", method_name
      return unless PerformLater.config.enabled?

      define_method "#{method_name}" do |*args|
        loner          = opts.fetch(:loner, false)
        queue          = opts.fetch(:queue, :generic)
        delay          = opts.fetch(:delay, false)
        klass          = PerformLater::Workers::ActiveRecord::Worker
        klass          = PerformLater::Workers::ActiveRecord::LoneWorker if loner
        args           = PerformLater::ArgsParser.args_to_resque(args)
        digest         = PerformLater::PayloadHelper.get_digest(klass, method_name, args)

        if loner
          return "AR EXISTS!" unless Resque.redis.get(digest).blank?
          Resque.redis.set(digest, 'EXISTS')
        end

        PerformLater::Job.new(queue, klass, send(:class).name, send(:id), "now_#{method_name}", *args).enqueue :delay => delay
      end
    end

  end

  def perform_later(queue, method, *args)
    return perform_now(method, args) if plugin_disabled?

    worker  = PerformLater::Workers::ActiveRecord::Worker
    job     = PerformLater::Job.new(queue, worker, self.class.name, self.id, method, *args) 

    enqueue_in_resque_or_send(job)
  end

  def perform_later!(queue, method, *args)
    return perfrom_now(method, args) if plugin_disabled?
    return "AR EXISTS!" if loner_exists(method, args)
    
    worker  = PerformLater::Workers::ActiveRecord::LoneWorker
    job     = PerformLater::Job.new(queue, worker, self.class.name, self.id, method, *args) 
    enqueue_in_resque_or_send(job)
  end

  def perform_later_in(delay, queue, method, *args)
    return perform_now(method, args) if plugin_disabled?

    worker  = PerformLater::Workers::ActiveRecord::Worker
    job     = PerformLater::Job.new(queue, worker, self.class.name, self.id, method, *args) 
    enqueue_in_resque_or_send(job, delay: delay)
  end
  
  def perform_later_in!(delay, queue, method, *args)
    return  perform_now(method, args) if plugin_disabled?

    worker  = PerformLater::Workers::ActiveRecord::LoneWorker
    job     = PerformLater::Job.new(queue, worker, self.class.name, self.id, method, *args) 
    enqueue_in_resque_or_send(job)
  end



  private 
    def loner_exists(method, args)
      args = PerformLater::ArgsParser.args_to_resque(args)
      digest = PerformLater::PayloadHelper.get_digest(self.class.name, method, args)

      return true unless Resque.redis.get(digest).blank?
      Resque.redis.set(digest, 'EXISTS')

      return false
    end

    def enqueue_in_resque_or_send(job, opts={})
      job.args = PerformLater::ArgsParser.args_to_resque(job.args)
      job.enqueue(opts)
    end
        
    def plugin_disabled?
      !PerformLater.config.enabled?
    end

    def perfrom_now(method, args)
      return self.send(method, *args)
    end
end
