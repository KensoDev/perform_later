module PerformLater
  module Workers
		class BaseWorker

		protected
			def self.perform_job(object, method, arguments)
				unless arguments.empty?
          if arguments.size == 1
            object.send(method, arguments.first)
          else
            object.send(method, *arguments)
          end
        else
          object.send(method)
        end
			end
		end 
	end
end