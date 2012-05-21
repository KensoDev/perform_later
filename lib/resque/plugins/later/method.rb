module Resque::Plugins::Later::Method
  extend ActiveSupport::Concern

  module ClassMethods
    def later(method_name, opts={})
      alias_method :"now_#{method_name}", method_name
      return unless PerformLater.enabled?
    
      define_method "#{method_name}" do |*args|
        klass          = ActiveRecordWorker
        queue          = opts[:queue] || "generic"

        args = ResquePerformLater.args_to_resque(args)

        Resque::Job.create(queue, klass, send(:class).name, send(:id), "now_#{method_name}", args)
      end
    end
  end
end