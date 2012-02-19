class ObjectWorker
  # @param klass_name [The class name that you should work on]
  # @param method [method you should send on the class]
  # @param args [method args]
  def self.perform(klass_name, method, *args)
    args = ResquePerformLater.args_from_resque(args)
    
    klass_name.constantize.send(method, *args)
  end
end
