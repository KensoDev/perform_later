class User < ActiveRecord::Base
  def long_running_method
    true
  end
  later :long_running_method

  def lonely_long_running_method
    true
  end
  later :lonely_long_running_method, :loner => true

  def self.get_metadata
    {}
  end
end