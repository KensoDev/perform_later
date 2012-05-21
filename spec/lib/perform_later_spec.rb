require 'spec_helper'

describe PerformLater do
  # Probably the simplest spec ever but still... ;)

  it "should set the perform later mode to enabled" do
    PerformLater.enabled?.should be_false
    PerformLater.enabled = true
    PerformLater.enabled?.should == true
  end

  it "should include the sync method on the user model" do
    User.new.should respond_to(:long_running_method)
    User.new.should respond_to(:now_long_running_method)
  end
end