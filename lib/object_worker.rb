class ObjectWorker
  # Public: perform.
  #
  # klass_name - name of the class (string).
  # method - method name, this method will be called on the object.
  # *args - array of arguments to send to the method
  #
  def self.perform(klass_name, method, *args)
    args = PerformLater::ArgsParser.args_from_resque(args)
    
    klass_name.constantize.send(method, *args)
  end
end
