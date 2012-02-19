module Resque
  module Mailer
    module ClassMethods
      def perform(action, *args)
        args = ResquePerformLater.args_from_resque(args)
        self.send(:new, action, *args).message.deliver
      end
    end

    class MessageDecoy
      def deliver
        args = ResquePerformLater.args_to_resque(@args)
        resque.enqueue(@mailer_class, @method_name, *args)
      end
    end
  end
end
