require 'perform_later/config'

describe PerformLater::Config do
  subject { PerformLater::Config }
  # Probably the simplest spec ever but still... ;)

  it "should set the perform later mode to enabled" do
    subject.enabled?.should be_false
    subject.enabled = true
    subject.enabled?.should == true
  end
end