require 'spec_helper'

describe PerformLater do
  # Probably the simplest spec ever but still... ;)

  it "should set the perform later mode to enabled" do
    PerformLater.config.enabled?.should be_true
    PerformLater.config.enabled = false
    PerformLater.config.enabled?.should == false
  end
end