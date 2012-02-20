class ActiveRecordWorker
  # Public: perform.
  #
  # klass_name - name of the class (string).
  # method - method name, this method will be called on the object.
  # *args - array of arguments to send to the method
  #
	def self.perform(klass, id, method, *args)
	  args = ResquePerformLater.args_from_resque(args)
	  runner_klass = eval(klass)
	  
	  record = runner_klass.where(:id => id).first
	  record.send(method, *args) if record
	end
end