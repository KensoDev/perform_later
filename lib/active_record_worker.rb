class ActiveRecordWorker
	def self.perform(klass, id, method, *args)
	  args = ResquePerformLater.args_from_resque(args)
	  runner_klass = eval(klass)
	  
	  record = runner_klass.where(:id => id).first
	  record.send(method, *args) if record
	end
end