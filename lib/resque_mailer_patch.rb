module Resque
  module Mailer
    module ClassMethods
      def perform(action, *args)
        args = PerformLater::ArgsParser.args_from_resque(args)
        self.send(:new, action, *args).message.deliver
      end
    end

    class MessageDecoy
      def deliver
        args = PerformLater::ArgsParser.args_to_resque(@args)
        resque.enqueue(@mailer_class, @method_name, *args)
      end
    end
  end
end