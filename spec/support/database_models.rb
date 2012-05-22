class User < ActiveRecord::Base
  def long_running_method
    # Your code here
  end
  later :long_running_method

  def long_running_method_2
    # Your code here
  end
  later :long_running_method_2, queue: :some_queue_name

  def lonely_long_running_method
    # Your code here
  end
  later :lonely_long_running_method, :loner => true, queue: :some_queue_name
end