require 'spec_helper'

describe PerformLater::Config do
  before(:each) { PerformLater.config.enabled = false }

  it "should set the perform later mode" do
    PerformLater.config.enabled?.should be_false
    PerformLater.config.enabled = true
    PerformLater.config.enabled?.should == true
  end
end