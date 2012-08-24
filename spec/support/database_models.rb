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

  def delayed_long_running_method
    # Your code here
  end
  later :delayed_long_running_method, :delay => 30, queue: :some_queue_name

  def method_with_hash_as_option(options = {})
    options[:some_option]
  end

  def method_with_integer_option(integer)
    integer
  end

end
