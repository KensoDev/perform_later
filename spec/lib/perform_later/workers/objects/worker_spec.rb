require 'spec_helper'

class DummyClass 
  def self.do_somthing_with_array_of_hashes(arr)
    arr[0][:foo]
  end
end

describe PerformLater::Workers::Objects::Worker do
  subject { PerformLater::Workers::Objects::Worker }

  it "should pass an array of hashes into the method" do
    
  end
end