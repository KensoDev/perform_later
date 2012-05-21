class User < ActiveRecord::Base
  def long_running_method
    
  end
  later :long_running_method
end