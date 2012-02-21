class User < ActiveRecord::Base
  def full_name
    "Avi Tzurel"
  end

  def self.get_metadata
    {}
  end
end