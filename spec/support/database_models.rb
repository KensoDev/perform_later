class User < ActiveRecord::Base
  def long_running_method
    true
  end

  later :long_running_method, queue: :some_queue, loner: true
end