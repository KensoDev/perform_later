require 'spec_helper'

describe PerformLater do
  # Probably the simplest spec ever but still... ;)

  it "should set the perform later mode to enabled" do
    PerformLater.enabled?.should be_false
    PerformLater.enabled = true
    PerformLater.enabled?.should == true
  end
end