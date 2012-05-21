class User < ActiveRecord::Base
  def long_running_method
    
  end
  later :long_running_method

  def full_name
    "Avi Tzurel"
  end

  def self.get_metadata
    {}
  end
end